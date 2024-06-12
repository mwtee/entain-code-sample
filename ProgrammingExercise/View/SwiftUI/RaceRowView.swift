import SwiftUI
import Combine

struct RaceRowView: View {
    static let reuseIdentifier = String(describing: RaceRowView.self)
    @ObservedObject private var viewModel: RaceRowViewModel

    init(viewModel: RaceRowViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            titleAndDate
            Spacer()
            remainingTime
        }
        .onAppear {
            self.viewModel.startObservingRaceStartDate()
        }
        .onDisappear {
            self.viewModel.stopObservingRaceStartDate()
        }
    }

    private var titleAndDate: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.meetingName)
                .primarySmallTitleMediumText()
            Text(viewModel.raceNumber)
                .secondarySmallTitleText()
        }
    }

    private var remainingTime: some View {
        Text(viewModel.remainingTimeText)
            .primarySmallTitleText()
    }
}
