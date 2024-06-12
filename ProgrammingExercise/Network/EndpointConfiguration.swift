import Foundation

enum EndpointConfiguration {
    static var baseURL: URL {
        guard let urlString =
                Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String,
              let url = URL(string: urlString)
        else {
            fatalError("BaseURL key must return a value")
        }
        return url
    }
}
