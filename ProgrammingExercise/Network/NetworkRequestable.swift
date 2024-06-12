import Foundation

protocol NetworkRequestable {
    associatedtype Response: Decodable
    
    var path: String { get }
    
    var queryItems: [URLQueryItem]? { get }
    
    var method: RequestMethod { get }

    var contentType: ContentType { get }

    var scheme: Scheme { get }
}
