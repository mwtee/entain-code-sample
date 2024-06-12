import Combine
import UIKit

final class RaceRowViewModel: ObservableObject {
    @Published var remainingTimeText: String = ""
    let meetingName: String
    let raceNumber: String
    private let startDate: Date
    private var cancellables: Set<AnyCancellable> = []

    init(model: RaceModel) {
        meetingName = model.meetingName
        raceNumber = "R\(model.raceNumber)"
        startDate = model.startDate
        remainingTimeText = formatRemainingTime(from: model.startDate)
    }

    deinit {
        stopObservingRaceStartDate()
    }

    func startObservingRaceStartDate() {
        stopObservingRaceStartDate()
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateRemainingTime()
            }
            .store(in: &cancellables)
    }

    func stopObservingRaceStartDate() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    private func updateRemainingTime() {
        self.remainingTimeText = formatRemainingTime(from: startDate)
    }

    private func formatRemainingTime(from startDate: Date) -> String {
        let remainingTime = startDate.timeIntervalSinceNow

        if remainingTime <= 0 {
            return "Started"
        }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated

        return formatter.string(from: remainingTime) ?? "0m 0s"
    }
}
