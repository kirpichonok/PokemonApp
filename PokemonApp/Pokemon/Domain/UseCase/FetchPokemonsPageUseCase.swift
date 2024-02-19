import Foundation

final class FetchPokemonsPageUseCase
{
    private let pokemonClient: PokemonClient

    init(pokemonClient: PokemonClient = DefaultPokemonClient())
    {
        self.pokemonClient = pokemonClient
    }

    func execute(_ page: Page) async throws -> PokemonPage
    {
        try await pokemonClient.getPokemonPage(page)
    }
}
