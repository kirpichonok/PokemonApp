import Foundation

protocol PokemonClient
{
    func getPokemonPage(_ page: Page) async throws -> PokemonPage
}
