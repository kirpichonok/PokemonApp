import Foundation

protocol FetchPokemonsPageUseCase
{
    func fetchPage(_ page: Page) async throws -> PokemonPage
}
