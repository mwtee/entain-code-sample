import Combine
import XCTest
@testable import ProgrammingExercise

final class NextRacesViewModelTests: XCTestCase {
    private var viewModel: NextRacesViewModel!
    private var mockRepository: MockNextRacesRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockNextRacesRepository()
        viewModel = NextRacesViewModel(repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockRepository = nil
        cancellables.forEach { $0.cancel() }
        cancellables = nil
    }

    func testProvidesScreenTitle() {
        XCTAssertEqual(viewModel.screenTitle, "Next to Go Races")
    }

    func testLoadDataSuccessTransitionsFromLoadingToLoaded() async {
        let loadedExpectation = XCTestExpectation(description: "Update is loaded")
        let loadingExpectation = XCTestExpectation(description: "Update is loading")

        viewModel.updatePublisher
            .sink { state in
                switch state {
                case .loaded:
                    loadedExpectation.fulfill()
                case .loading:
                    loadingExpectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)

        viewModel.loadData()

        let result = await XCTWaiter().fulfillment(
            of: [loadingExpectation, loadedExpectation],
            timeout: 1,
            enforceOrder: true
        )
        XCTAssertEqual(result, .completed)
    }

    func testLoadDataFailureTransitionsFromLoadingToFailed() async {
        mockRepository = MockNextRacesRepository(shouldMockError: true)
        viewModel = NextRacesViewModel(repository: mockRepository)
        let failedExpectation = XCTestExpectation(description: "Update is failed")
        let loadingExpectation = XCTestExpectation(description: "Update is loading")

        viewModel.updatePublisher
            .sink { state in
                switch state {
                case let .failed(error):
                    XCTAssertTrue(error is MockError)
                    failedExpectation.fulfill()
                case .loading:
                    loadingExpectation.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)

        viewModel.loadData()

        let result = await XCTWaiter().fulfillment(
            of: [loadingExpectation, failedExpectation],
            timeout: 1
        )
        XCTAssertEqual(result, .completed)
    }

    func testFilterRacesByCategoryGreyhound() async {
        await testFilterRaces(by: .greyhound)
    }

    func testFilterRacesByCategoryHarness() async {
        await testFilterRaces(by: .harness)
    }

    func testFilterRacesByCategoryHorse() async {
        await testFilterRaces(by: .horse)
    }

    func testNumberOfRowsInSectionWhenNoDataAvailableReturnsZero() {
        let numberOfRows = viewModel.numberOfRowsInSection(0)
        XCTAssertEqual(numberOfRows, 0)
    }

    func testBindingCallsLoadDataAgainWhenRaceStartedForOneMinute() async {
        let startedRace = MockModelFactory.createMockRaceModel(
            raceID: "4", startDate: Date().addingTimeInterval(-60)
        )
        mockRepository.raceModels.append(startedRace)
        await loadDataAndWaitForLoadedUpdate()

        let loadingExpectation = XCTestExpectation(description: "Update is loading")
        let loadedExpectation = XCTestExpectation(description: "Update is loaded")

        viewModel.updatePublisher.dropFirst()
            .sink { state in
                if case .loading = state {
                    loadingExpectation.fulfill()
                }

                if case .loaded = state {
                    loadedExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        let result = await XCTWaiter().fulfillment(
            of: [loadingExpectation, loadedExpectation],
            timeout: 1,
            enforceOrder: true
        )
        XCTAssertEqual(result, .completed)
    }
}

// MARK: - Test helpers
extension NextRacesViewModelTests {
    private func testFilterRaces(by category: RaceModel.Category) async {
        mockRepository.raceModels.append(contentsOf: [
            MockModelFactory.createMockRaceModel(raceID: "2", category: .harness),
            MockModelFactory.createMockRaceModel(raceID: "3", category: .horse)
        ])
        await loadDataAndWaitForLoadedUpdate()

        let filteredExpectation = XCTestExpectation(description: "Races are filtered for \(category)")

        viewModel.updatePublisher.dropFirst()
            .sink { [weak self] state in
                if case .loaded = state {
                    XCTAssertEqual(self?.viewModel.numberOfRowsInSection(0), 1)
                    if case let .race(model) = self?.viewModel.rowModel(forSection: 0, row: 0) {
                        XCTAssertEqual(model.category, category)
                    } else {
                        XCTFail("Race model should be set during loaded state")
                    }
                    filteredExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.filterRaces(by: category)

        let result = await XCTWaiter().fulfillment(
            of: [filteredExpectation],
            timeout: 1
        )
        XCTAssertEqual(result, .completed)
    }

    private func loadDataAndWaitForLoadedUpdate() async {
        let loadedExpectation = XCTestExpectation(description: "Update is loaded")

        viewModel.updatePublisher
            .sink { state in
                if case .loaded = state {
                    loadedExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadData()

        let result = await XCTWaiter().fulfillment(
            of: [loadedExpectation],
            timeout: 1
        )
        XCTAssertEqual(result, .completed)
    }
}
