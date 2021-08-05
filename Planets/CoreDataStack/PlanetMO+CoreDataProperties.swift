//
//  PlanetMO+CoreDataProperties.swift
//  Planets
//
//  Created by Dilip Patidar on 05/08/21.
//
//

import Foundation
import CoreData


extension PlanetMO {

    @nonobjc public class func fetchRequestForPlanets() -> NSFetchRequest<PlanetMO> {
        return NSFetchRequest<PlanetMO>(entityName: "PlanetMO")
    }

    @NSManaged public var diameter: String
    @NSManaged public var name: String
    @NSManaged public var population: String
    @NSManaged public var url: String
}

extension PlanetMO : Identifiable {

}
