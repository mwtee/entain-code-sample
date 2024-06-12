import Foundation

enum NextRacesUpdate {
    case initial
    case loading
    case loaded
    case failed(Error)
}
