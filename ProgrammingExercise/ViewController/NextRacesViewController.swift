import UIKit
import Combine

final class NextRacesViewController: UIViewController, AlertPresentable {
    private let tableView: NextRacesTableView
    private let viewModel: NextRacesViewModelProtocol
    private let routeNavigator: RouteNavigatable
    private var cancellables = Set<AnyCancellable>()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let filterButton = UIButton(type: .system)

    init(
        viewModel: NextRacesViewModelProtocol,
        dataProvider: NextRacesTableViewDataProvider,
        routeNavigator: RouteNavigatable
    ) {
        self.viewModel = viewModel
        self.routeNavigator = routeNavigator
        self.tableView = NextRacesTableView(dataProvider: dataProvider)
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("Disabled init")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupFilterButton()
        setupTableView()
        setupActivityIndicator()
        bindViewModel()
        viewModel.loadData()
    }

    private func setupNavigationBar() {
        tabBarController?.title = viewModel.screenTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func setupFilterButton() {
        view.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.setTitle("Filter", for: .normal)
        filterButton.menu = createFilterMenu()
        filterButton.showsMenuAsPrimaryAction = true

        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func createFilterMenu() -> UIMenu {
        let allAction = UIAction(
            title: "All",
            handler: { [weak self] _ in self?.filterRaces(by: nil) }
        )
        let horseAction = UIAction(
            title: "Horse",
            handler: { [weak self] _ in self?.filterRaces(by: .horse) }
        )
        let harnessAction = UIAction(
            title: "Harness", 
            handler: { [weak self] _ in self?.filterRaces(by: .harness) }
        )
        let greyhoundAction = UIAction(
            title: "Greyhound",
            handler: { [weak self] _ in self?.filterRaces(by: .greyhound) }
        )

        return UIMenu(
            title: "Filter Races",
            children: [allAction, horseAction, harnessAction, greyhoundAction]
        )
    }

    private func bindViewModel() {
        viewModel.updatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleUpdates(state)
            }
            .store(in: &cancellables)

        viewModel.routePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] route in
                self?.handleRoute(route)
            }
            .store(in: &cancellables)
    }

    private func handleUpdates(_ update: NextRacesUpdate) {
        switch update {
        case .initial:
            activityIndicator.stopAnimating()
        case .loading:
            activityIndicator.startAnimating()
        case .loaded:
            activityIndicator.stopAnimating()
            tableView.reload()
        case let .failed(error):
            activityIndicator.stopAnimating()
            showErrorAlert(error: error)
        }
    }

    private func handleRoute(_ route: Route) {
        routeNavigator.navigate(route: route)
    }

    private func showErrorAlert(error: Error) {
        presentAlert(
            title: "Error",
            message: error.localizedDescription,
            actions: [
                .init(
                    title: "Dismiss",
                    style: .default
                ),
                .init(
                    title: "Retry",
                    style: .default,
                    handler: { [weak self] _ in self?.viewModel.loadData() }
                ),
            ]
        )
    }

    private func filterRaces(by category: RaceModel.Category?) {
        viewModel.filterRaces(by: category)
    }
}
