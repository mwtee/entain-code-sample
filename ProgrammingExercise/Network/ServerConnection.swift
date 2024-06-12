import Foundation

protocol ServerConnectable {
    func executeNetworkRequestAsync<T: NetworkRequestable>(_ request: T) async throws -> T.Response
}

final class ServerConnection: ServerConnectable {
    
    private let networkSession: NetworkSession
    private let baseURL: String
    
    init(
        networkSession: NetworkSession,
        baseURL: String
    ) {
        self.networkSession = networkSession
        self.baseURL = baseURL
    }
        
    func executeNetworkRequestAsync<T: NetworkRequestable>(_ request: T) async throws -> T.Response {
        let urlRequest = try createURLRequest(from: request)
        
        let (data, response) = try await networkSession.response(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpError(0)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.Response.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    private func createURLRequest(from request: any NetworkRequestable) throws -> URLRequest  {
        var components = URLComponents()
        components.scheme = request.scheme.rawValue
        components.host = baseURL
        components.path = request.path
        components.queryItems = request.queryItems

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue(request.contentType.rawValue, forHTTPHeaderField: "Content-Type")

        return urlRequest
    }
}

