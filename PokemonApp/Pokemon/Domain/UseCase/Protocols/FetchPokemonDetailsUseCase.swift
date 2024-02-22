import Foundation

protocol FetchPokemonDetailsUseCase
{
    func fetchPokemonDetails(for pokemon: PokemonPreview) async throws -> Pokemon
    func fetchPokemonImage(with path: String) async throws -> Data
}
