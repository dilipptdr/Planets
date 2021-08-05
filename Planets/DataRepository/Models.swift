//
//  Models.swift
//  Planets
//
//  Created by Dilip Patidar on 03/08/21.
//

import Foundation

// MARK: model objects
struct Planet: Codable {

    let name: String
    let population: String
    let diameter: String
    let url: String
}

struct PlanetList: Codable {
    var count: Int
    var planets: [Planet]

    enum CodingKeys: String, CodingKey {
        case planets = "results"
        case count
    }
}

