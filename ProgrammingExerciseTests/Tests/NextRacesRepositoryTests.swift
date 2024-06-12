import XCTest
@testable import ProgrammingExercise

final class NextRacesRepositoryTests: XCTestCase {
    private var mockNextRacesService: MockNextRacesService!

    override func setUp()  {
        super.setUp()
        mockNextRacesService = MockNextRacesService()
    }

    override func tearDown()  {
        super.tearDown()
        mockNextRacesService = nil
    }

    func testRetrieveNextRaceModelsCallsNextRacesService() async {
        let nextRacesRepository = NextRacesRepository(
            nextRacesService: mockNextRacesService,
            raceModelsMapping: { _ in [MockModelFactory.createMockRaceModel()] }
        )

        do {
            _ = try await nextRacesRepository.retrieveNextRaceModels()
            let fetchNextRacesCalled = try XCTUnwrap(mockNextRacesService.fetchNextRacesCalled)
            XCTAssertTrue(fetchNextRacesCalled)
        } catch {
            XCTFail("Error \(error) thrown instead of success")
        }
    }

    func testRetrieveNextRaceModelsSuccessReturnsTheMappedRaceModels() async {
        let mockStartDate = Date(timeIntervalSince1970: 1718019240)
        let nextRacesRepository = NextRacesRepository(
            nextRacesService: mockNextRacesService,
            raceModelsMapping: { _ in [MockModelFactory.createMockRaceModel(startDate: mockStartDate)] }
        )

        do {
            let raceModels = try await nextRacesRepository.retrieveNextRaceModels()
            XCTAssertEqual(raceModels.count, 1)

            let raceModel = raceModels.first
            XCTAssertEqual(raceModel?.startDate, mockStartDate)
            XCTAssertEqual(raceModel?.raceID, "2e9d9880-dd26-43df-bace-50e4680d143d")
            XCTAssertEqual(raceModel?.meetingName, "Swindon Bags")
            XCTAssertEqual(raceModel?.raceNumber, "6")
        } catch {
            XCTFail("Error \(error) thrown instead of success")
        }
    }

    func testRetrieveNextRaceModelsFailureReturnsErrorFromNextRacesService() async {
        mockNextRacesService = MockNextRacesService(mockFailure: true)
        let nextRacesRepository = NextRacesRepository(
            nextRacesService: mockNextRacesService,
            raceModelsMapping: { _ in [MockModelFactory.createMockRaceModel()] }
        )

        do {
            _ = try await nextRacesRepository.retrieveNextRaceModels()
            XCTFail("Error is expected")
        } catch {
            XCTAssertTrue(error is MockError)
        }
    }

    func testRetrieveNextRaceModelsUsesCachedDataWhenAvailable() async {
        let mockStartDate = Date(timeIntervalSinceNow: 3600)
        let nextRacesRepository = NextRacesRepository(
            nextRacesService: mockNextRacesService,
            raceModelsMapping: { _ in [
                MockModelFactory.createMockRaceModel(startDate: mockStartDate),
                MockModelFactory.createMockRaceModel(startDate: mockStartDate),
                MockModelFactory.createMockRaceModel(startDate: mockStartDate),
                MockModelFactory.createMockRaceModel(startDate: mockStartDate),
                MockModelFactory.createMockRaceModel(startDate: mockStartDate),
                MockModelFactory.createMockRaceModel(startDate: mockStartDate)
            ] }
        )

        // First call to prepare data
        do {
            let raceModels = try await nextRacesRepository.retrieveNextRaceModels()
            XCTAssertEqual(raceModels.count, 5)
            mockNextRacesService.fetchNextRacesCalled = nil
        } catch {
            XCTFail("Error \(error) thrown instead of success")
        }

        // Second call should use the cached data
        do {
            let raceModels = try await nextRacesRepository.retrieveNextRaceModels()
            XCTAssertEqual(raceModels.count, 5)
            XCTAssertNil(mockNextRacesService.fetchNextRacesCalled)
        } catch {
            XCTFail("Error \(error) thrown instead of success")
        }
    }

    func testRetrieveNextRaceModelsFiltersOutPastRaces() async {
        let nextRacesRepository = NextRacesRepository(
            nextRacesService: mockNextRacesService,
            raceModelsMapping: { _ in [
                MockModelFactory.createMockRaceModel(startDate: Date(timeIntervalSinceNow: -58)),
                MockModelFactory.createMockRaceModel(startDate: Date(timeIntervalSinceNow: -59)),
                MockModelFactory.createMockRaceModel(startDate: Date(timeIntervalSinceNow: -60)),
                MockModelFactory.createMockRaceModel(startDate: Date(timeIntervalSinceNow: -3600)),
                MockModelFactory.createMockRaceModel(startDate: Date(timeIntervalSinceNow: 3600))
            ]}
        )

        // First call to prepare data
        do {
            let raceModels = try await nextRacesRepository.retrieveNextRaceModels()
            XCTAssertEqual(raceModels.count, 5)
        } catch {
            XCTFail("Error \(error) thrown instead of success")
        }


        // Second call should remove past start date races
        do {
            let raceModels = try await nextRacesRepository.retrieveNextRaceModels()
            // Expect three because only startDate past 1 minute will be removed.
            // In this case it is, -60 and -3600, thus 2 races are removed.
            XCTAssertEqual(raceModels.count, 3)
        } catch {
            XCTFail("Error \(error) thrown instead of success")
        }
    }
}
