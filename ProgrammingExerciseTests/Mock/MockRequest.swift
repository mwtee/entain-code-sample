import Foundation
@testable import ProgrammingExercise

struct MockRequest: NetworkRequestable {
    typealias Response = MockResponse
    
    var path: String = "/mock/path/"

    var queryItems: [URLQueryItem]?
    
    var method: RequestMethod = .get

    var contentType: ContentType = .json

    var scheme: Scheme = .https
}
