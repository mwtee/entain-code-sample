import XCTest
@testable import ProgrammingExercise

final class RaceModelTests: XCTestCase {
    private var response: NextRacesResponse!
    private var raceModels: [RaceModel]!

    override func setUp() {
        super.setUp()
        response = MockModelFactory.createMockNextRacesResponse()
        raceModels = RaceModel.mapArray(from: response)
    }

    override func tearDown() {
        super.tearDown()
        response = nil
        raceModels = nil
    }

    func testRaceModelMapCountMatchesResponseRaces() throws {
        XCTAssertEqual(raceModels.count, 3)
    }

    func testRaceModelOrderingMatchesResponseNextToGoIDs() throws {
        XCTAssertEqual(raceModels[0].raceID, "7cefe53c-86f2-856e-bade-9fb2d9a24bp2")
        XCTAssertEqual(raceModels[0].meetingName, "John Park")
        XCTAssertEqual(raceModels[0].raceNumber, "9")
        XCTAssertEqual(raceModels[0].startDate, Date(timeIntervalSince1970: 1718019300))

        XCTAssertEqual(raceModels[1].raceID, "2e9d9880-dd26-43df-bace-50e4680d143d")
        XCTAssertEqual(raceModels[1].meetingName, "Swindon Bags")
        XCTAssertEqual(raceModels[1].raceNumber, "6")
        XCTAssertEqual(raceModels[1].startDate, Date(timeIntervalSince1970: 1718019240))

        XCTAssertEqual(raceModels[2].raceID, "5cebe53c-76f2-488e-bdba-7fb1d9a24bf1")
        XCTAssertEqual(raceModels[2].meetingName, "Sandown Park")
        XCTAssertEqual(raceModels[2].raceNumber, "9")
        XCTAssertEqual(raceModels[2].startDate, Date(timeIntervalSince1970: 1718019300))
    }

    func testRaceModelMapsCategoryBasedOnCategoryID() throws {
        XCTAssertEqual(raceModels[0].category, .horse)
        XCTAssertEqual(raceModels[1].category, .greyhound)
        XCTAssertEqual(raceModels[2].category, .harness)
    }
}
