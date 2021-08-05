//
//  NetworkService.swift
//  Planets
//
//  Created by Dilip Patidar on 03/08/21.
//

import Foundation
import Combine

// MARK: Network data types

enum NetworkError: Error {
    case malformedURL
}

// MARK: NetworkService
protocol NetworkServiceProtocol {
    func httpRequestPublisher(for url: URL) -> URLSession.DataTaskPublisher
}

// MARK: NetworkService implementation
struct NetworkService: NetworkServiceProtocol {
    func httpRequestPublisher(for url: URL) -> URLSession.DataTaskPublisher {
        URLSession.shared.dataTaskPublisher(for: url)
    }
}
