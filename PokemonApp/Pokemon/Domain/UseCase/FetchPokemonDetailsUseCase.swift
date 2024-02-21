import Foundation

final class FetchPokemonDetailsUseCase
{
    private let pokemonDetailsClient: PokemonDetailsClient

    init(pokemonDetailsClient: PokemonDetailsClient = DefaultPokemonDetailsClient())
    {
        self.pokemonDetailsClient = pokemonDetailsClient
    }

    func fetchPokemonDetails(for pokemon: PokemonPreview) async throws -> Pokemon
    {
        try await pokemonDetailsClient.getPokemonDetails(for: pokemon)
    }
}
