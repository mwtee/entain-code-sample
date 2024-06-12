import Foundation

struct MockResponse: Decodable {
    let name: String
}

extension MockResponse {
    static let JSONData: Data = """
    {
        "name": "Mock Name"
    }
    """
        .data(using: .utf8)!
}
