import XCTest
@testable import ProgrammingExercise

final class NextRacesRequestTests: XCTestCase {
    func testInitialization() {
        let request = NextRacesRequest()
        let expectedQueryItems = [
            URLQueryItem(name: "method", value: "nextraces"),
            URLQueryItem(name: "count", value: "10")
        ]

        XCTAssertEqual(request.path, "/rest/v1/racing/")
        XCTAssertEqual(request.queryItems, expectedQueryItems)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.scheme, .https)
        XCTAssertEqual(request.contentType, .json)
    }

    func testInitializationtWithCustomRaceCountLimit() {
        let request = NextRacesRequest(raceCountLimit: 20)
        let expectedQueryItems = [
            URLQueryItem(name: "method", value: "nextraces"),
            URLQueryItem(name: "count", value: "20")
        ]

        XCTAssertEqual(request.path, "/rest/v1/racing/")
        XCTAssertEqual(request.queryItems, expectedQueryItems)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.scheme, .https)
        XCTAssertEqual(request.contentType, .json)
    }
}
