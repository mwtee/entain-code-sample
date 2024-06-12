import XCTest
@testable import ProgrammingExercise

final class DependencyContainerTests: XCTestCase {
    func testResolvingRegisteredDependencyReturnsCorrectly() {
        let container = AppDependencyContainer()
        let mockDependency = MockDependency()
        container.register(MockDependencyProtocol.self) { mockDependency }

        let resolvedDependency = container.resolve(MockDependencyProtocol.self)

        XCTAssertTrue(resolvedDependency === mockDependency)
    }
}

private protocol MockDependencyProtocol: AnyObject {
    func mock()
}

private class MockDependency: MockDependencyProtocol {
    func mock() {}
}
