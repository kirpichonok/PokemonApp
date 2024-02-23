import Foundation

final class FetchPokemonsPageUseCaseMock: FetchPokemonsPageUseCase
{
    var fetchPokemonListCalled = false
    var fetchPokemonListCalledCount = 0

    func fetchPokemonList(page _: Page) async throws -> PokemonPage
    {
        fetchPokemonListCalled = true
        fetchPokemonListCalledCount += 1
        return PokemonPage(list: [
            DummyData.testPokemonPreview,
        ],
        totalCount: 1)
    }
}
