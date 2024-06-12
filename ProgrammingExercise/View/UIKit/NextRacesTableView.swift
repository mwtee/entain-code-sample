import Combine
import SwiftUI
import UIKit

final class NextRacesTableView: UITableView {
    private let dataProvider: NextRacesTableViewDataProvider
    private var cancellables = Set<AnyCancellable>()

    init(dataProvider: NextRacesTableViewDataProvider) {
        self.dataProvider = dataProvider
        super.init(frame: .zero, style: .plain)
        dataSource = self
        delegate = self
        register(
            UITableViewCell.self,
            forCellReuseIdentifier: RaceRowView.reuseIdentifier
        )
        bindToDataProvider()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("Disabled init")
    }

    func reload() {
        self.reloadData()
    }

    private func bindToDataProvider() {
        dataProvider.dataUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.reload()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource
extension NextRacesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = dataProvider.rowModel(forSection: indexPath.section, row: indexPath.row)
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RaceRowView.reuseIdentifier,
            for: indexPath
        )

        switch cellModel {
        case let .race(model):
            cell.contentConfiguration = UIHostingConfiguration {
                RaceRowView(viewModel: .init(model: model))
            }
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension NextRacesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NextRacesTableViewDataProvider
protocol NextRacesTableViewDataProvider {
    var dataUpdatePublisher: AnyPublisher<[NextRacesRowModel], Never> { get }
    func rowModel(forSection section: Int, row: Int) -> NextRacesRowModel
    func numberOfRowsInSection(_ section: Int) -> Int
}
