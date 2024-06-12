import Foundation
@testable import ProgrammingExercise

final class MockNetworkSession: NetworkSession {
    private(set) var request: URLRequest?

    private let response: Response?
    private let error: URLError?

    init(
        response: Response? = nil,
        error: URLError? = nil
    ) {
        self.response = response
        self.error = error
    }

    func response(for request: URLRequest) async throws -> Response {
        self.request = request

        if let response {
            return (response.data, response.response)
        } else if let error {
            throw error
        } else {
            fatalError("Mock must be given either error or data")
        }
    }
}

