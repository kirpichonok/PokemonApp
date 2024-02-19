import Foundation

final class FetchPokemonsPageUseCase
{
    private let pokemonClient: PokemonClient

    init(pokemonClient: PokemonClient = DefaultPokemonClient())
    {
        self.pokemonClient = pokemonClient
    }

    func execute(with endpoint: ApiEndpoint) async throws -> PokemonPage
    {
        try await pokemonClient.getPokemonPage(from: endpoint)
    }
}
