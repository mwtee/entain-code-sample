import XCTest
@testable import ProgrammingExercise

final class NextRacesResponseTests: XCTestCase {

    func testNextRacesResponseDecoding() throws {
        guard let url = Bundle.main.url(forResource: "GETNextRaces", withExtension: "json") else {
            XCTFail("Missing file GETNextRaces.json")
            return
        }

        let jsonData = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let response = try decoder.decode(NextRacesResponse.self, from: jsonData)
        let raceSummaryOne = response.data.raceSummaries["2e9d9880-dd26-43df-bace-50e4680d143d"]
        let raceSummaryTwo = response.data.raceSummaries["5cebe53c-76f2-488e-bdba-7fb1d9a24bf1"]

        XCTAssertEqual(response.status, 200)
        XCTAssertEqual(response.data.nextToGoIDs.count, 2)
        XCTAssertEqual(response.data.nextToGoIDs[0], "2e9d9880-dd26-43df-bace-50e4680d143d")
        XCTAssertEqual(response.data.nextToGoIDs[1], "5cebe53c-76f2-488e-bdba-7fb1d9a24bf1")

        XCTAssertEqual(raceSummaryOne?.raceID, "2e9d9880-dd26-43df-bace-50e4680d143d")
        XCTAssertEqual(raceSummaryOne?.raceName, "Race 6")
        XCTAssertEqual(raceSummaryOne?.raceNumber, 6)
        XCTAssertEqual(raceSummaryOne?.categoryId, "9daef0d7-bf3c-4f50-921d-8e818c60fe61")
        XCTAssertEqual(raceSummaryOne?.meetingName, "Swindon Bags")
        XCTAssertEqual(raceSummaryOne?.advertisedStart.seconds, 1718019240)

        XCTAssertEqual(raceSummaryTwo?.raceID, "5cebe53c-76f2-488e-bdba-7fb1d9a24bf1")
        XCTAssertEqual(raceSummaryTwo?.raceName, "Sandowngreyhounds.com.au Damsels Dash")
        XCTAssertEqual(raceSummaryTwo?.raceNumber, 9)
        XCTAssertEqual(raceSummaryTwo?.categoryId, "9daef0d7-bf3c-4f50-921d-8e818c60fe61")
        XCTAssertEqual(raceSummaryTwo?.meetingName, "Sandown Park")
        XCTAssertEqual(raceSummaryTwo?.advertisedStart.seconds, 1718019300)
    }
}
