import Foundation

protocol PokemonClient
{
    func getPokemonPage(from endpoint: ApiEndpoint) async throws -> PokemonPage
}
