import Foundation

protocol NextRacesRepositoryProtocol {
    func retrieveNextRaceModels() async throws -> [RaceModel]
}

final class NextRacesRepository: NextRacesRepositoryProtocol {
    private let nextRacesService: NextRacesServicing
    private let raceModelsMapping: (NextRacesResponse) -> [RaceModel]
    private var cachedRaceModels: [RaceModel] = []

    init(
        nextRacesService: NextRacesServicing,
        raceModelsMapping: @escaping (NextRacesResponse) -> [RaceModel]
    ) {
        self.nextRacesService = nextRacesService
        self.raceModelsMapping = raceModelsMapping
    }

    private func retrieveRaceModels() async throws -> [RaceModel] {
        let response = try await nextRacesService.fetchNextRaces()
        let raceModels = raceModelsMapping(response)
        cachedRaceModels = raceModels.sorted { $0.startDate < $1.startDate }
        return cachedRaceModels
    }

    func retrieveNextRaceModels() async throws -> [RaceModel] {
        cachedRaceModels.removeAll { $0.startDate.timeIntervalSinceNow <= -60 }

        // Skip network request if cachedModels has more than 5 races
        if cachedRaceModels.count >= 5 {
            return Array(cachedRaceModels.prefix(5))
        }

        let response = try await nextRacesService.fetchNextRaces()
        let newRaceModels = raceModelsMapping(response)

        let existingRaceIDs = Set(cachedRaceModels.map { $0.raceID })
        let filteredNewRaces = newRaceModels.filter { !existingRaceIDs.contains($0.raceID) }

        cachedRaceModels.append(contentsOf: filteredNewRaces)
        cachedRaceModels = cachedRaceModels.sorted { $0.startDate < $1.startDate }

        return Array(cachedRaceModels.prefix(5))
    }
}
