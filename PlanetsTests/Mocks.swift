//
//  Mocks.swift
//  PlanetsTests
//
//  Created by Dilip Patidar on 05/08/21.
//

import Combine
import Foundation
@testable import Planets

struct MockData {
    static let planets =
        [
            Planet(name: "Earth", population: "7000000000", diameter: "87678", url: "earth.com"),
            Planet(name: "Mercury", population: "786", diameter: "232", url: "Mercury.com"),
            Planet(name: "Venus", population: "8348976", diameter: "84789", url: "Venus.com"),
            Planet(name: "Mars", population: "3876487", diameter: "2323232", url: "Mars.com"),
            Planet(name: "Jupiter", population: "38432", diameter: "7767", url: "Jupiter.com"),
            Planet(name: "Saturn", population: "932874893", diameter: "565765", url: "Saturn.com"),
            Planet(name: "Uranus", population: "398479813", diameter: "21219897", url: "Uranus.com"),
            Planet(name: "Neptune", population: "3482364", diameter: "98798623", url: "Neptune.com")
        ]
}

final class CoreDataClientMock: CoreDataClientProtocol {
    var saveMethodCalled = false

    func planets() -> AnyPublisher<[Planet], Error> {
        return Just(MockData.planets).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func save(planets: [Planet]) {
        saveMethodCalled = true
    }
}

struct WebClientMock: WebClientProtocol {
    func planets() -> AnyPublisher<[Planet], Error> {
        return Just(MockData.planets).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
