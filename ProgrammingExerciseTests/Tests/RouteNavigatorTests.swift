import XCTest
@testable import ProgrammingExercise

final class RouteNavigatorTests: XCTestCase {
    func testRouteNavigateToRaceDetailsPushesViewController() {
        let mockNavigator = MockNavigator()
        let routeNavigator = RouteNavigator(navigator: mockNavigator)

        routeNavigator.navigate(
            route: .navigateToRaceDetails
        )

        XCTAssertNotNil(mockNavigator.pushedViewController)
    }
}
