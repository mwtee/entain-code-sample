import Foundation

struct RaceModel {
    let raceID: String
    let category: Category
    let meetingName: String
    let raceNumber: String
    let startDate: Date
}

extension RaceModel {
    enum Category {
        case greyhound
        case harness
        case horse
    }
}

extension RaceModel {
    static func mapArray(from response: NextRacesResponse) -> [RaceModel] {
        let raceSummaries = response.data.raceSummaries

        return response.data.nextToGoIDs.compactMap { raceID in
            guard let summary = raceSummaries[raceID] else { return nil }

            let startDate = Date(timeIntervalSince1970: TimeInterval(summary.advertisedStart.seconds))
            let category: Category
            switch summary.categoryId {
            case "9daef0d7-bf3c-4f50-921d-8e818c60fe61":
                category = .greyhound
            case "161d9be2-e909-4326-8c2c-35ed71fb460b":
                category = .harness
            case "4a2788f8-e825-4d36-9894-efd4baf1cfae":
                category = .horse
            default:
                return nil
            }

            return RaceModel(
                raceID: summary.raceID,
                category: category,
                meetingName: summary.meetingName,
                raceNumber: String(summary.raceNumber),
                startDate: startDate
            )
        }
    }
}
