import Combine
import Foundation

protocol NextRacesViewModelProtocol {
    var updatePublisher: AnyPublisher<NextRacesUpdate, Never> { get }
    var routePublisher: AnyPublisher<Route, Never> { get }
    var screenTitle: String { get }
    func loadData()
    func filterRaces(by category: RaceModel.Category?)
}

final class NextRacesViewModel: NextRacesViewModelProtocol {
    var updatePublisher: AnyPublisher<NextRacesUpdate, Never> {
        updateSubject.eraseToAnyPublisher()
    }

    var routePublisher: AnyPublisher<Route, Never> {
        routeSubject.eraseToAnyPublisher()
    }

    let screenTitle: String = "Next to Go Races"

    private var sectionModels: [NextRacesSectionModel] = []
    private var raceModels: [RaceModel] = []
    private var selectedCategory: RaceModel.Category?
    private let repository: NextRacesRepositoryProtocol
    private let updateSubject = CurrentValueSubject<NextRacesUpdate, Never>(.initial)
    private let routeSubject = PassthroughSubject<Route, Never>()
    private var cancellables: Set<AnyCancellable> = []

    init(repository: NextRacesRepositoryProtocol) {
        self.repository = repository
        startObservingForRaceStarted()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    func loadData() {
        DispatchQueue.main.async { [weak self] in
            self?.updateSubject.send(.loading)
        }
        Task {
            do {
                try await loadRaces()
            } catch {
                handleError(error)
            }
        }
    }

    private func loadRaces() async throws {
        raceModels = try await repository.retrieveNextRaceModels()
        filterAndLoadSection()
    }

    private func filterAndLoadSection() {
        let filteredRaces = raceModels
            .filter { race in
                guard let category = selectedCategory else { return true }
                return race.category == category
            }

        sectionModels = [createRacesSectionModel(from: filteredRaces)]

        DispatchQueue.main.async { [weak self] in
            self?.updateSubject.send(.loaded)
        }
    }

    private func handleError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.updateSubject.send(.failed(error))
        }
    }

    func filterRaces(by category: RaceModel.Category?) {
        selectedCategory = category
        filterAndLoadSection()
    }

    private func createRacesSectionModel(from models: [RaceModel]) -> NextRacesSectionModel {
        return .init(
            sectionType: .races,
            rows: NextRacesRowModel.mapArray(from: models)
        )
    }

    private func startObservingForRaceStarted() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkIfRaceStarted()
            }
            .store(in: &cancellables)
    }

    private func checkIfRaceStarted() {
        guard let sectionIndex = sectionIndex(for: .races) else {
            return
        }
        let oneMinuteAgo = Date().addingTimeInterval(-60)
        let hasRaceStarted = sectionModels[sectionIndex].rows
            .compactMap {
                if case let .race(model) = $0 {
                    return model.startDate
                }
                return nil
            }
            .contains { $0 <= oneMinuteAgo }

        if hasRaceStarted { loadData() }
    }

    private func sectionIndex(for sectionType: NextRacesSectionModel.SectionType) -> Int? {
        return sectionModels.firstIndex { $0.sectionType == sectionType }
    }
}

// MARK: - NextRacesTableViewDataProvider

extension NextRacesViewModel: NextRacesTableViewDataProvider {
    var dataUpdatePublisher: AnyPublisher<[NextRacesRowModel], Never> {
        updateSubject
            .compactMap { update -> [NextRacesRowModel]? in
                guard case .loaded = update else { return nil }

                // TODO extract the exact sections later
                return self.sectionModels.flatMap { $0.rows }
            }
            .eraseToAnyPublisher()
    }

    func rowModel(forSection section: Int, row: Int) -> NextRacesRowModel {
        sectionModels[section].rows[row]
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        guard !sectionModels.isEmpty else {
            return .zero
        }
        return sectionModels[section].rows.count
    }
}
