//
//  DataRepository.swift
//  Planets
//
//  Created by Dilip Patidar on 03/08/21.
//

import Combine
import Foundation


// MARK: PlanetRepositoryProtocol

/// PlanetRepositoryProtocol contains method to provide data to the viewModel layer
/// Its responsibiliyt is to collect data either from CoreData or Web depdending on the business logic, in this case
/// whether network is available or not
/// PlanetRepository manages data from both DB and network and works as an abstraction layer on top of both
protocol PlanetRepositoryProtocol {
    func planets() -> AnyPublisher<[Planet], Error>
}

// MARK: PlanetRepository Implementation

/// Implementation of PlanetRepositoryProtocol and the business logic to provide data to view model layer, either from CoreData or network
final class PlanetRepository: PlanetRepositoryProtocol {

    private let dataClient: CoreDataClientProtocol
    private let webClient: WebClientProtocol

    private var cancellables = [AnyCancellable] ()

    init(dataClient: CoreDataClientProtocol, webClient: WebClientProtocol) {
        self.dataClient = dataClient
        self.webClient = webClient
    }

    func planets() -> AnyPublisher<[Planet], Error> {

        // check for network connection, if not avaialble get the data from CoreData

        switch NetworkStatusManager.shared.networkStatus {
        case .connected:
            // if connected to network fetch data from web an sync to CoreData
            let publisher = webClient.planets()
            publisher
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            print("request failed: \(error.localizedDescription)")
                        case .finished:
                            print("request completed successfully")
                        }
                    },
                    receiveValue: { planets in
                        // sync values fetched from web client to the CoreData
                        self.dataClient.save(planets: planets)
                    })
            .store(in: &cancellables)
            return publisher

        case .notConnected:
        // if not connected to network fetch data CoreData
            return dataClient.planets()
        }
    }
}
