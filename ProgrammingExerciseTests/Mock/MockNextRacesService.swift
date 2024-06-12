@testable import ProgrammingExercise

final class MockNextRacesService: NextRacesServicing {
    var fetchNextRacesCalled: Bool?
    var mockFailure = false

    init(mockFailure: Bool = false) {
        self.mockFailure = mockFailure
    }

    func fetchNextRaces() async throws -> NextRacesResponse {
        fetchNextRacesCalled = true
        if mockFailure {
            throw MockError.dummyError
        } else {
            return MockModelFactory.createMockNextRacesResponse()
        }
    }
}
