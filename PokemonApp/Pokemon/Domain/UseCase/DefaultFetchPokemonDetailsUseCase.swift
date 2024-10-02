import Foundation

final class DefaultFetchPokemonDetailsUseCase: FetchPokemonDetailsUseCase {
    private let pokemonDetailsClient: PokemonDetailsClient
    private let pokemonImageClient: PokemonImageClient

    init(
        pokemonDetailsClient: PokemonDetailsClient,
        pokemonImageClient: PokemonImageClient
    ) {
        self.pokemonDetailsClient = pokemonDetailsClient
        self.pokemonImageClient = pokemonImageClient
    }

    func fetchPokemonDetails(for pokemon: PokemonPreview) async throws -> Pokemon {
        try await pokemonDetailsClient.getPokemonDetails(for: pokemon)
    }

    func fetchPokemonImage(with path: String) async throws -> Data {
        try await pokemonImageClient.getImage(with: path)
    }
}
