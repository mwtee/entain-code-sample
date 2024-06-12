import XCTest
@testable import ProgrammingExercise

final class AppLaunchCoordinatorTests: XCTestCase {
    private var mockContainer: MockDependencyContainer!
    private var mockWindow: UIWindow!
    private var appLaunchCoordinator: AppLaunchCoordinator!

    override func setUp() {
        super.setUp()
        mockContainer = MockDependencyContainer()
        mockWindow = UIWindow()
        appLaunchCoordinator = AppLaunchCoordinator(
            window: mockWindow,
            container: mockContainer
        )
    }

    override func tearDown() {
        super.tearDown()
        mockContainer = nil
        mockWindow = nil
        appLaunchCoordinator = nil
    }

    func testDependencyRegistrationExecutesRegistrationOnContainer() {
        appLaunchCoordinator.registerDependecies()

        XCTAssertNotNil(mockContainer.registrations[String(describing: RouteNavigatable.self)])
        XCTAssertNotNil(mockContainer.registrations[String(describing: ServerConnectable.self)])
    }

    func testSetupRootViewControllerSetRootViewTabBarControllerEmbededInNavigationController() {
        mockContainer.register(RouteNavigatable.self) { MockRouteNavigator() }
        mockContainer.register(NextRacesRepositoryProtocol.self) { MockNextRacesRepository() }

        appLaunchCoordinator.setupRootViewController()
        XCTAssertTrue(mockWindow.rootViewController?.children.first is RootViewTabBarController)
        XCTAssertTrue(mockWindow.rootViewController is UINavigationController)
    }
}

private final class MockRouteNavigator: RouteNavigatable {
    func navigate(route: Route) {}
}
