protocol FetchPokemonsPageUseCase {
    func fetchPokemonList(page: Page) async throws -> PokemonPage
}
