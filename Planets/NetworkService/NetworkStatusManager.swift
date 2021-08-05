//
//  NetworkStatusManager.swift
//  Planets
//
//  Created by Dilip Patidar on 03/08/21.
//

import Combine
import Foundation
import Network

@frozen
enum NetworkStatus {
    case connected
    case notConnected
}

final class NetworkStatusManager: ObservableObject {

    static let shared = NetworkStatusManager()

    let objectWillChange =  ObservableObjectPublisher()

    @Published
    private (set) var networkStatus: NetworkStatus = .connected

    init() {}

    private let queue = DispatchQueue(label: "NetworkMonitor", target: DispatchQueue.global())

    func startMonitoring() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.networkStatus = .connected
            } else {
                self.networkStatus = .connected
            }
        }
        monitor.start(queue: queue)
    }
}
