import Foundation

final class DefaultPokemonDetailsClient: PokemonDetailsClient
{
    private let networkService: NetworkService

    init(networkService: NetworkService )
    {
        self.networkService = networkService
    }

    func getPokemonDetails(for pokemon: PokemonPreview) async throws -> Pokemon
    {
        guard let url = URL(string: pokemon.pathToDetails) else { throw ClientError.invalidUrl }
        let endpoint: ApiEndpoint = .pokemonDetails(url: url)
        do
        {
            let response: PokemonDetailsDataModel = try await networkService.request(to: endpoint)
            let page = response.toDomain()
            return page
        }
        catch
        {
            throw error.convertToClientError()
        }
    }
}
