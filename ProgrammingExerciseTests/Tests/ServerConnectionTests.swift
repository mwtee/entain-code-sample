import XCTest
@testable import ProgrammingExercise

final class ServerConnectableTests: XCTestCase {
    private var serverConnection: ServerConnection!
    private var networkSession: MockNetworkSession!

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        serverConnection = nil
    }
        
    func testExecuteNetworkRequestAsyncWithSuccessfulResponse() async {
        serverConnection = createServerConnection(statusCode: 200)
        do {
            let response = try await serverConnection.executeNetworkRequestAsync(MockRequest())
            XCTAssertEqual(response.name, "Mock Name")
        } catch {
            XCTFail("Receive error \(error) instead of success.")
        }
    }
    
    func testExecuteNetworkRequestAsyncWithFailureResponse() async {
        serverConnection = createServerConnection(statusCode: 408)
        do {
            let response = try await serverConnection.executeNetworkRequestAsync(MockRequest())
            XCTFail("Receive response \(response) instead of error.")
        } catch let NetworkError.httpError(code) {
            XCTAssertEqual(code, 408)
        } catch {
            XCTFail("Receive error \(error) instead of HTTP error.")
        }
    }
    
    func testExecuteNetworkRequestAsyncWithDecodingFailure() async throws {
        let mockJSONdata = try XCTUnwrap("".data(using: .utf8))
        serverConnection = createServerConnection(statusCode: 200, JSONData: mockJSONdata)
        do {
            let response = try await serverConnection.executeNetworkRequestAsync(MockRequest())
            XCTFail("Receive response \(response) instead of error.")
        } catch NetworkError.decodingError {
            XCTAssertTrue(true, "Decoding error was successfully caught as expected.")
        } catch {
            XCTFail("Receive error \(error) instead of decoding error.")
        }
    }
    
    func testExecuteNetworkRequestAyncWithInvalidURLPath() async {
        serverConnection = createServerConnection()
        var mockRequest = MockRequest()
        mockRequest.path = "www.invalid.com///invalid///path///"

        do {
            let response = try await serverConnection.executeNetworkRequestAsync(mockRequest)
            XCTFail("Receive response \(response) instead of error.")
        } catch NetworkError.invalidURL {
            XCTAssertTrue(true, "Invalid URL error was successfully caught as expected.")
        } catch {
            XCTFail("Receive error \(error) instead of invalid URL error.")
        }
    }
}

// MARK: - Test Helpers

private func createServerConnection(
    baseURL: String = "api.neds.com.au",
    statusCode: Int = 200,
    JSONData: Data = MockResponse.JSONData
) -> ServerConnection {
    let response = (
        JSONData,
        mockURLResponse(statusCode: statusCode)
    )
    let networkSession = MockNetworkSession(response: response)
    return ServerConnection(
        networkSession: networkSession,
        baseURL: baseURL
    )
}

private func mockURLResponse(
    statusCode: Int = 200,
    headers: [String: String]? = nil
) -> URLResponse {
    return HTTPURLResponse(
        url: URL(string: "www.test.com")!,
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: headers
    )!
}
