import XCTest
@testable import ProgrammingExercise

final class EndpointConfigurationTests: XCTestCase {
    func testBaseURLReturnsDebugURL() {
        // Assume we will only run unit test runs in debug configuration for the current scope
        XCTAssertEqual(
            EndpointConfiguration.baseURL,
            URL(string: "api.neds.com.au")
        )
    }
}
