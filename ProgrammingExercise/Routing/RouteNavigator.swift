import UIKit

protocol RouteNavigatable {
    func navigate(route: Route)
}

final class RouteNavigator: RouteNavigatable {
    private let navigator: Navigatable

    init(navigator: Navigatable) {
        self.navigator = navigator
    }

    func navigate(route: Route) {
        switch route {
        case .navigateToRaceDetails:
            // Push a RaceDetailsViewController for the real implementation
            navigator.pushViewController(UIViewController(), animated: true)
        }
    }
}
