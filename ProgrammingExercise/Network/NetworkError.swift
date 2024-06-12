import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case httpError(Int)
    case undefinedError(Error)
    case decodingError(Error)
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
          switch (lhs, rhs) {
          case (.invalidURL, .invalidURL):
              return true
          case (let .httpError(code1), let .httpError(code2)):
              return code1 == code2
          case (let .undefinedError(error1), let .undefinedError(error2)):
              return type(of: error1) == type(of: error2)
          case (let .decodingError(error1), let .decodingError(error2)):
              return type(of: error1) == type(of: error2)
          default:
              return false
          }
      }
}
