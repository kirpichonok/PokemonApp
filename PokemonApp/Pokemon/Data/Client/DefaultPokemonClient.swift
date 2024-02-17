import Foundation

class DefaultPokemonClient: PokemonClient
{
    private let networkService: NetworkService

    init(networkService: NetworkService)
    {
        self.networkService = networkService
    }

    func getPokemonPage(from endpoint: ApiEndpoint) async throws -> PokemonPage
    {
        let response: PokemonPageDataModel = try await networkService.request(to: endpoint)
        return response.toDomain()
    }
}
