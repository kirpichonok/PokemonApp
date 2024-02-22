import Foundation

final class FetchPokemonsPageUseCase
{
    private let pokemonClient: PokemonClient

    init(pokemonClient: PokemonClient)
    {
        self.pokemonClient = pokemonClient
    }

    func fetchPokemonList(page: Page) async throws -> PokemonPage
    {
        try await pokemonClient.getPokemonList(page: page)
    }
}
