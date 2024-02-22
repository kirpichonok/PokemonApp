import Foundation

final class DefaultPokemonImageClient: PokemonImageClient
{
    private let networkService: NetworkService

    init(networkService: NetworkService)
    {
        self.networkService = networkService
    }

    func getImage(with path: String) async throws -> Data
    {
        guard let url = URL(string: path) else { throw ClientError.invalidUrl }
        let endpoint: ApiEndpoint = .image(url: url)
        do
        {
            return try await networkService.request(to: endpoint)
        }
        catch
        {
            throw error.convertToClientError()
        }
    }
}
