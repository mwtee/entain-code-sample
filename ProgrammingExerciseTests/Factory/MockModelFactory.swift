import Foundation
@testable import ProgrammingExercise

struct MockModelFactory {

    static func createFutureDate(byAdding seconds: TimeInterval) -> Date {
        return Date().addingTimeInterval(seconds)
    }

    static func createMockRaceModel(
        raceID: String = "2e9d9880-dd26-43df-bace-50e4680d143d",
        category: RaceModel.Category = .greyhound,
        meetingName: String = "Swindon Bags",
        raceNumber: String = "6",
        startDate: Date = Date(timeIntervalSince1970: 1718019240)
    ) -> RaceModel {
        return RaceModel(
            raceID: raceID,
            category: category,
            meetingName: meetingName,
            raceNumber: raceNumber,
            startDate: startDate
        )
    }

    static func createMockNextRacesResponse() -> NextRacesResponse {

        let raceSummaryOne = createMockRaceSummaryResponse(
            raceID: "2e9d9880-dd26-43df-bace-50e4680d143d",
            raceName: "Race 6",
            raceNumber: 6,
            meetingName: "Swindon Bags",
            categoryId: "9daef0d7-bf3c-4f50-921d-8e818c60fe61",
            advertisedStartSeconds: 1718019240
        )

        let raceSummaryTwo = createMockRaceSummaryResponse(
            raceID: "5cebe53c-76f2-488e-bdba-7fb1d9a24bf1",
            raceName: "Sandowngreyhounds.com.au Damsels Dash",
            raceNumber: 9,
            meetingName: "Sandown Park",
            categoryId: "161d9be2-e909-4326-8c2c-35ed71fb460b",
            advertisedStartSeconds: 1718019300
        )

        let raceSummaryThree = createMockRaceSummaryResponse(
            raceID: "7cefe53c-86f2-856e-bade-9fb2d9a24bp2",
            raceName: "Dash",
            raceNumber: 9,
            meetingName: "John Park",
            categoryId: "4a2788f8-e825-4d36-9894-efd4baf1cfae",
            advertisedStartSeconds: 1718019300
        )

        let raceSummaries = [
            "2e9d9880-dd26-43df-bace-50e4680d143d": raceSummaryOne,
            "5cebe53c-76f2-488e-bdba-7fb1d9a24bf1": raceSummaryTwo,
            "7cefe53c-86f2-856e-bade-9fb2d9a24bp2": raceSummaryThree
        ]

        let raceData = NextRacesResponse.RaceData(
            nextToGoIDs: [
                "7cefe53c-86f2-856e-bade-9fb2d9a24bp2",
                "2e9d9880-dd26-43df-bace-50e4680d143d",
                "5cebe53c-76f2-488e-bdba-7fb1d9a24bf1"
            ],
            raceSummaries: raceSummaries
        )

        return .init(
            status: 200,
            data: raceData
        )
    }

    static func createMockRaceSummaryResponse(
        raceID: String,
        raceName: String,
        raceNumber: Int,
        meetingName: String,
        categoryId: String,
        advertisedStartSeconds: Int
    ) -> NextRacesResponse.RaceData.RaceSummary {
        return .init(
            raceID: raceID,
            raceName: raceName,
            raceNumber: raceNumber,
            meetingName: meetingName,
            categoryId: categoryId,
            advertisedStart: .init(seconds: advertisedStartSeconds)
        )
    }
}
