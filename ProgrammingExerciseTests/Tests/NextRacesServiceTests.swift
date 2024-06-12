import XCTest
@testable import ProgrammingExercise

final class NextRacesServiceTests: XCTestCase {
    private var mockServerConnection: MockServerConnection<NextRacesResponse>!
    private var nextRacesService: NextRacesService!

    override func setUp() {
        super.setUp()
        mockServerConnection = MockServerConnection<NextRacesResponse>()
        nextRacesService = NextRacesService(serverConnection: mockServerConnection)
    }

    override func tearDown() {
        super.tearDown()
        nextRacesService = nil
        mockServerConnection = nil
    }

    func testFetchNextRacesSuccessReturnsResponse() async {
        let expectedResponse = stubResponse()

        mockServerConnection = MockServerConnection(mockResponse: expectedResponse)
        nextRacesService = NextRacesService(serverConnection: mockServerConnection)

        do {
            let response = try await nextRacesService.fetchNextRaces()
            XCTAssertEqual(response.status, expectedResponse.status)
            XCTAssertEqual(response.data.nextToGoIDs, expectedResponse.data.nextToGoIDs)
            XCTAssertEqual(response.data.raceSummaries.count, expectedResponse.data.raceSummaries.count)

            for (key, expectedSummary) in expectedResponse.data.raceSummaries {
                guard let actualSummary = response.data.raceSummaries[key] else {
                    XCTFail("Missing race summary key. The key should all match")
                    return
                }

                XCTAssertEqual(actualSummary.raceID, expectedSummary.raceID)
                XCTAssertEqual(actualSummary.raceName, expectedSummary.raceName)
                XCTAssertEqual(actualSummary.raceNumber, expectedSummary.raceNumber)
                XCTAssertEqual(actualSummary.meetingName, expectedSummary.meetingName)
                XCTAssertEqual(actualSummary.categoryId, expectedSummary.categoryId)
                XCTAssertEqual(actualSummary.advertisedStart.seconds, expectedSummary.advertisedStart.seconds)
            }
        } catch {
            XCTFail("Expected success")
        }
    }

    func testFetchNextRacesFailureReturnsError() async {
        let expectedError = NetworkError.httpError(500)
        mockServerConnection = MockServerConnection(error: expectedError)
        nextRacesService = NextRacesService(serverConnection: mockServerConnection)

        do {
            _ = try await nextRacesService.fetchNextRaces()
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as? NetworkError, expectedError)
        }
    }

    private func stubResponse() -> NextRacesResponse {
        guard let filePath = Bundle.main.path(forResource: "GETNextRaces", ofType: "json") else {
            fatalError("JSON file path must exist")
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let response = try JSONDecoder().decode(NextRacesResponse.self, from: data)
            return response
        } catch {
            fatalError("Failed to load mock response from file: \(error)")
        }
    }
}
