import XCTest
@testable import ProgrammingExercise

final class ArrayExtensionTests: XCTestCase {
    private let array = ["One", "Two"]

    func testSafeSubscriptReturnsTheCorrectElement() {
        XCTAssertEqual(array[safe: 0], "One")
        XCTAssertEqual(array[safe: 1], "Two")
    }

    func testSafeSubscriptReturnsNilForOutOfBoundsIndex() {
        XCTAssertNil(array[safe: 3])
        XCTAssertNil(array[safe: -1])
    }
}
