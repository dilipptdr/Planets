//
//  CoreDataClient.swift
//  Planets
//
//  Created by Dilip Patidar on 03/08/21.
//

import Combine
import CoreData
import Foundation

// MARK: Core Data client

/// CoreDataClientProtocol's responsibility is to fetch and save data to CoreData
protocol CoreDataClientProtocol {
    /// Retrievs core data objects from DB
    func planets() -> AnyPublisher<[Planet], Error>

    /// Saves data to DB
    /// - Parameter planets: an array of planet objects
    func save(planets: [Planet])
}

// MARK: Core Data client implementation

/// Implemnetation for CoreDataClientProtocol. Its depdency will be the CoreData Stack. It will use core data objects to fetch and save data to DB
struct CoreDataClient: CoreDataClientProtocol {

    private let coreData: CoreDataStack

    init(coreData: CoreDataStack) {
        self.coreData = coreData
    }

    /// Fetch planets data fron DB using main context, so, this method is safe to be called form main thread
    /// - Returns: an array of planets
    func planets() -> AnyPublisher<[Planet], Error> {
        // use viewContext object context for read operations as this could be useedin the UI thread

        let fetchRequest = PlanetMO.fetchRequestForPlanets()

        var results: [PlanetMO]?

        do {
             results = try coreData.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch planets datafrom DB \(error)")
        }

        if let planetsMOArray = results {
            let planets = planetsMOArray.map {
                Planet(name: $0.name, population: $0.population, diameter: $0.diameter, url: $0.url)
            }
            return Just(planets).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    /// This method saves changes to DB which come from network response
    /// - Parameter planets: array of planets, for exmaple - recieved from network request
    func save(planets: [Planet]) {

        // use backgroundmanaged object context for write operations

        let bgContext = coreData.persistentContainer.newBackgroundContext()

        bgContext.perform {

            for planet in planets {
                let planetMO = PlanetMO(context: bgContext)
                planetMO.name = planet.name
                planetMO.diameter = planet.diameter
                planetMO.url = planet.url
                planetMO.population = planet.population
            }

            if bgContext.hasChanges {
                do {
                    try bgContext.save()
                } catch {
                    let nserror = error as NSError
                    assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}

