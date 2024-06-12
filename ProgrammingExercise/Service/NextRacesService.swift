import Foundation

protocol NextRacesServicing {
    func fetchNextRaces() async throws -> NextRacesResponse
}

final class NextRacesService: NextRacesServicing {

    private let serverConnection: ServerConnectable

    init(
        serverConnection: ServerConnectable
    ) {
        self.serverConnection = serverConnection
    }

    func fetchNextRaces() async throws -> NextRacesResponse {
        return try await serverConnection
            .executeNetworkRequestAsync(NextRacesRequest())

    }
}
