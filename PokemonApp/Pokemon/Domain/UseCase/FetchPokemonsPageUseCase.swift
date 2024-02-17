import Foundation

final class FetchPokemonsPageUseCase
{
    private let pokemonClient: PokemonClient

    init(pokemonClient: PokemonClient)
    {
        self.pokemonClient = pokemonClient
    }

    func fetchPage(from endpoint: ApiEndpoint) async throws -> PokemonPage
    {
        try await pokemonClient.getPokemonPage(from: endpoint)
    }
}
