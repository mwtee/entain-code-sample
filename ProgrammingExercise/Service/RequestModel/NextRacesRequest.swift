import Foundation

struct NextRacesRequest: NetworkRequestable {
    typealias Response = NextRacesResponse

    let path: String = "/rest/v1/racing/"
    var queryItems: [URLQueryItem]?
    let method: RequestMethod = .get
    let contentType: ContentType = .json
    let scheme: Scheme = .https

    init(raceCountLimit: Int = 10) {
        queryItems = [
            URLQueryItem(name: "method", value: "nextraces"),
            URLQueryItem(name: "count", value: "\(raceCountLimit)")
        ]
    }
}
