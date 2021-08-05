//
//  PlanetListViewModel.swift
//  Planets
//
//  Created by Dilip Patidar on 04/08/21.
//

import Combine
import Foundation

// MARK: Planet list view models

struct PlanetListCellViewData {
    let name: String
}

protocol PlanetListViewModelProtocol {
    var sections: Int { get }
    var cellModels: [PlanetListCellViewData] { get }
    var cellModelPublisher: AnyPublisher<Void, Never> { get }
    func items(in section: Int) -> Int
    func cellViewModel(for item: Int, in section: Int) -> PlanetListCellViewData
    func didSelect(item at: Int, in section: Int)
}

// MARK: Planet list view model implementatinos

final class PlanetListViewModel: PlanetListViewModelProtocol {

    // for now we just have one section in the list view
    let sections: Int = 1

    var cellModels = [PlanetListCellViewData]()

    private var cancellables = [AnyCancellable] ()

    private let repository: PlanetRepositoryProtocol

    var cellModelPublisher: AnyPublisher<Void, Never>
    
    private let internalCellModelPublisher: PassthroughSubject<Void, Never>  = PassthroughSubject()

    init(repository: PlanetRepositoryProtocol) {

        self.repository = repository

        cellModelPublisher = internalCellModelPublisher.eraseToAnyPublisher()

        self.repository.planets()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] planets in
                    guard let self = self else { return }

                    let cellModels = planets.map { PlanetListCellViewData(name: $0.name) }
                    self.cellModels = cellModels
                    self.internalCellModelPublisher.send()
                }
            )
            .store(in: &cancellables)
    }

    func items(in section: Int) -> Int {
        cellModels.count
    }

    func cellViewModel(for item: Int, in section: Int) -> PlanetListCellViewData {
        cellModels[item]
    }

    func didSelect(item at: Int, in section: Int) {
        // logic to be performed when an item in the list is selected
        // We should bubble up this call to the co-ordinator to handle any navigation when an item is selected
    }
}


