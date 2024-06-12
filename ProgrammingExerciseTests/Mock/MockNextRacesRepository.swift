@testable import ProgrammingExercise

final class MockNextRacesRepository: NextRacesRepositoryProtocol {
    private let shouldMockError: Bool
    var raceModels: [RaceModel]

    init(
        shouldMockError: Bool = false,
        raceModels: [RaceModel] = [MockModelFactory.createMockRaceModel()]
    ) {
        self.shouldMockError = shouldMockError
        self.raceModels = raceModels
    }

    func retrieveRaceModels() async throws -> [RaceModel] {
        if shouldMockError {
            throw MockError.dummyError
        } else {
            return raceModels
        }
    }

    func retrieveNextRaceModels() async throws -> [RaceModel] {
        if shouldMockError {
            throw MockError.dummyError
        } else {
            return raceModels
        }
    }
}
