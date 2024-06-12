import Foundation

extension URLSession: NetworkSession {
    func response(
        for request: URLRequest
    ) async throws -> Response {
        return try await data(for: request)
    }
}
