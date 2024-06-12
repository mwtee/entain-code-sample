enum NextRacesRowModel {
    case race(RaceModel)
}

extension NextRacesRowModel {
    static func mapArray(from models: [RaceModel]) -> [Self] {
        return models.map { .race($0) }
    }
}
