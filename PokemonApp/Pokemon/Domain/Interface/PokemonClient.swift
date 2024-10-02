import Foundation

protocol PokemonClient {
    func getPokemonList(page: Page) async throws -> PokemonPage
}
