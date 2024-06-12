import UIKit

final class AppLaunchCoordinator {
    private let window: UIWindow
    private let container: DependencyContaining
    private let navigationController: UINavigationController = UINavigationController()

    init(
        window: UIWindow,
        container: DependencyContaining
    ) {
        self.window = window
        self.container = container
    }

    func setupRootViewController() {
        let rootViewTabBarController = RootViewTabBarController(
            nextRacesRepository: container.resolve(NextRacesRepositoryProtocol.self),
            routeNavigator: container.resolve(RouteNavigatable.self)
        )
        navigationController.viewControllers = [rootViewTabBarController]
        rootViewTabBarController.setupChildViewControllers()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func registerDependecies() {
        container.register(RouteNavigatable.self) { [unowned self] in
            RouteNavigator(navigator: self.navigationController)
        }

        container.register(ServerConnectable.self) {
            ServerConnection(
                networkSession: URLSession.shared,
                baseURL: EndpointConfiguration.baseURL.absoluteString
            )
        }

        container.register(NextRacesServicing.self) { [unowned self] in
            return NextRacesService(
                serverConnection: self.container.resolve(ServerConnectable.self)
            )
        }

        container.register(NextRacesRepositoryProtocol.self) { [unowned self] in
            NextRacesRepository(
                nextRacesService: self.container.resolve(NextRacesServicing.self),
                raceModelsMapping: RaceModel.mapArray
            )
        }
    }
}
