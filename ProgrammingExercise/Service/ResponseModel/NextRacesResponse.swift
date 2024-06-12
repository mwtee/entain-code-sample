import Foundation

// MARK: - NextRacesResponse
struct NextRacesResponse: Decodable {
    let status: Int
    let data: RaceData

    enum CodingKeys: String, CodingKey {
        case status
        case data
    }
}

// MARK: - RaceData
extension NextRacesResponse {
    struct RaceData: Decodable {
        let nextToGoIDs: [String]
        let raceSummaries: [String: RaceSummary]

        enum CodingKeys: String, CodingKey {
            case nextToGoIDs = "next_to_go_ids"
            case raceSummaries = "race_summaries"
        }
    }
}

// MARK: - RaceSummary
extension NextRacesResponse.RaceData {
    struct RaceSummary: Decodable {
        let raceID: String
        let raceName: String
        let raceNumber: Int
        let meetingName: String
        let categoryId: String
        let advertisedStart: AdvertisedStart

        enum CodingKeys: String, CodingKey {
            case raceID = "race_id"
            case raceName = "race_name"
            case raceNumber = "race_number"
            case meetingName = "meeting_name"
            case categoryId = "category_id"
            case advertisedStart = "advertised_start"
        }
    }
}

// MARK: - AdvertisedStart
extension NextRacesResponse.RaceData.RaceSummary {
    struct AdvertisedStart: Decodable {
        let seconds: Int
    }
}
