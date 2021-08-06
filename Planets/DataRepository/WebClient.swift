//
//  WebClient.swift
//  Planets
//
//  Created by Dilip Patidar on 03/08/21.
//

import Combine
import Foundation

// MARK: Web client

/// WebClientProtocol's responsibility is to fetch data from network
protocol WebClientProtocol {
    func planets() -> AnyPublisher<[Planet], Error>
}

// MARK: Web client implementation

/// Implementation for WebClientProtocol responsibility is to fetch data from network
/// It has dependencies on NetworkService which is used to make network connection and fetch data from network
struct WebClient: WebClientProtocol {

    private let planetsURLString = "https://swapi.py4e.com/api/planets/" // https://swapi.dev/api/planets/"

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func planets() -> AnyPublisher<[Planet], Error> {

        guard let url = URL(string: planetsURLString) else {
            return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let publisher = networkService.httpRequestPublisher(for: url)
            .mapError(){ error in
                return error
             }
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: PlanetList.self, decoder: JSONDecoder())
            .map { $0.planets }

         return publisher.eraseToAnyPublisher()
    }
}
