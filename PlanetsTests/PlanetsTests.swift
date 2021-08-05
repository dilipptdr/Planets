//
//  PlanetsTests.swift
//  PlanetsTests
//
//  Created by Dilip Patidar on 03/08/21.
//

import Combine
import XCTest
@testable import Planets

class PlanetsTests: XCTestCase {

    private var planetRepository: PlanetRepositoryProtocol!
    private var planetListViewModel: PlanetListViewModelProtocol!

    private var cancellables = [AnyCancellable]()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        planetRepository = PlanetRepository(dataClient: CoreDataClientMock(), webClient: WebClientMock())

        planetListViewModel = PlanetListViewModel(repository: planetRepository)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// PlanetRepository functionalities
    /// - Throws: error
    func testPlanetRepository() throws {
        let expectationForPlanetData = XCTestExpectation(description: "expectationForPlanetData")
        let expectationCompleteWithoutFailure = XCTestExpectation(description: "expectationCompleteWithoutFailure")
        planetRepository.planets().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectationCompleteWithoutFailure.fulfill()
            case .failure( _):
                XCTAssert(false)
                expectationCompleteWithoutFailure.fulfill()
            }

        }, receiveValue: { planets in
            XCTAssertEqual(planets.count, MockData.planets.count)
            expectationForPlanetData.fulfill()
        }
        )
        .store(in: &cancellables)
    }

    /// Test to validate View model
    /// - Throws: error
    func testViewModel() throws {
        XCTAssertEqual(self.planetListViewModel.cellModels.count, MockData.planets.count)
        XCTAssertEqual(self.planetListViewModel.sections, 1)
        XCTAssertEqual(self.planetListViewModel.cellViewModel(for: 0, in: 1).name, MockData.planets[0].name)
    }
}
