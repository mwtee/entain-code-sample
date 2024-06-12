import Combine
import XCTest
@testable import ProgrammingExercise

final class RaceRowViewModelTests: XCTestCase {
    private var viewModel: RaceRowViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables.forEach { $0.cancel() }
        cancellables = nil
        super.tearDown()
    }

    func testRemainingTimeTextMatchesTheRaceFutureDate() {
        let startDate = MockModelFactory.createFutureDate(byAdding: 3600)
        let model = MockModelFactory.createMockRaceModel(startDate: startDate)
        viewModel = RaceRowViewModel(model: model)

        XCTAssertEqual(viewModel.remainingTimeText, "59min. 59s.")
    }

    func testRemainingTimeTextSetToStartedWhenTheRaceDateIsInThePast() {
        let startDate = MockModelFactory.createFutureDate(byAdding: 1)
        let model = MockModelFactory.createMockRaceModel(startDate: startDate)
        viewModel = RaceRowViewModel(model: model)

        let remainingTimeExpectation = XCTestExpectation(description: "Remaining time text updates to 'Started'")

        viewModel.$remainingTimeText
            .sink { remainingTimeText in
                if remainingTimeText == "Started" {
                    remainingTimeExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.startObservingRaceStartDate()

        let result = XCTWaiter().wait(for: [remainingTimeExpectation], timeout: 2)
        XCTAssertEqual(result, .completed)
    }
}
