import Foundation

final class PokemonListViewModel: ObservableObject
{
    @Published private(set) var listOfPokemons = [String]()

    private let fetchPokemonsUseCase: FetchPokemonsPageUseCase
    private var currentPage: PokemonPage?
    {
        didSet
        {
            guard let currentPage else { return }
            listOfPokemons = currentPage.list.map { $0.name }
        }
    }

    init(fetchPokemonsUseCase: FetchPokemonsPageUseCase)
    {
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
    }

    func fetchPokemons() async
    {
        do
        {
            currentPage = try await fetchPokemonsUseCase.fetchPage(from: .initialPage)
        }
        catch
        {
            print(error)
        }
    }
}
