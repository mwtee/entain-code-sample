import Foundation

protocol NetworkSession {
    typealias Response = (data: Data, response: URLResponse)
        
    func response(
        for request: URLRequest
    ) async throws -> Response
}
