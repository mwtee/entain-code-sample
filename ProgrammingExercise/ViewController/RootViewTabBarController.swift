import UIKit

final class RootViewTabBarController: UITabBarController {
    private let nextRacesViewController: NextRacesViewController

    init(
        nextRacesRepository: NextRacesRepositoryProtocol,
        routeNavigator: RouteNavigatable
    ) {
        nextRacesViewController = Self.createNextRacesViewController(
            nextRacesRepository: nextRacesRepository,
            routeNavigator: routeNavigator
        )
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("Disabled init")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppUIColor.primaryBackground
    }

    func setupChildViewControllers() {
        nextRacesViewController.tabBarItem = UITabBarItem(
            title: "Races",
            image: .init(systemName: "list.clipboard"),
            selectedImage: nil
        )
        viewControllers = [ nextRacesViewController ]
    }
}

extension RootViewTabBarController {
    private static func createNextRacesViewController(
        nextRacesRepository: NextRacesRepositoryProtocol,
        routeNavigator: RouteNavigatable
    ) -> NextRacesViewController {
        let viewModel = NextRacesViewModel(repository: nextRacesRepository)
        return .init(
            viewModel: viewModel,
            dataProvider: viewModel,
            routeNavigator: routeNavigator)
    }
}
