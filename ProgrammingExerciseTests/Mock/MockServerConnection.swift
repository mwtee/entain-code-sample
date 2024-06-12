import Foundation
@testable import ProgrammingExercise

final class MockServerConnection<MockResponse: Decodable>: ServerConnectable {
    private(set) var mockResponse: MockResponse?
    private(set) var error: Error?
    private(set) var request: Any?

    init(
        mockResponse: MockResponse? = nil,
        error: Error? = nil
    ) {
        self.mockResponse = mockResponse
        self.error = error
    }

    func executeNetworkRequestAsync<T>(_ request: T) async throws -> T.Response where T : NetworkRequestable {
        self.request = request
        if let error = error {
            throw error
        }
        if let mockResponse = mockResponse as? T.Response {
            return mockResponse
        }
        fatalError("MockServerConnection not properly configured. Please provide response or error")
    }
}
