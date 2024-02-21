import Foundation

protocol PokemonDetailsClient
{
    func getPokemonDetails(for pokemon: PokemonPreview) async throws -> Pokemon
}
