import CoreData
import Foundation

final class DefaultPokemonImageClient: PokemonImageClient {
    private let networkService: NetworkService
    private let coreDataStorage: PokemonImageStorage

    init(
        networkService: NetworkService,
        imageStorage: PokemonImageStorage
    ) {
        self.networkService = networkService
        coreDataStorage = imageStorage
    }

    func getImage(with path: String) async throws -> Data {
        guard let url = URL(string: path) else { throw ClientError.invalidUrl }
        let endpoint: ApiEndpoint = .image(url: url)
        do {
            return try await networkService.request(to: endpoint)
        } catch {
            throw error.convertToClientError()
        }
    }
}
