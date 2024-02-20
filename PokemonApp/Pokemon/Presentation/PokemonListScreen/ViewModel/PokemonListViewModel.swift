import Foundation

final class PokemonListViewModel: ObservableObject
{
    // MARK: - Properties

    @MainActor
    @Published private(set) var listOfPokemons = [String]()
    private(set) var errorMessage = ""
    {
        didSet
        {
            isErrorOccurred = !errorMessage.isEmpty
        }
    }

    @Published private(set) var isErrorOccurred = false
    @Published private(set) var nextPageDisabled = true
    @Published private(set) var previousPageDisabled = true

    // MARK: - Private properties

    private let fetchPokemonsUseCase: FetchPokemonsPageUseCase
    private var currentPage: PokemonPage?

    init(fetchPokemonsUseCase: FetchPokemonsPageUseCase = FetchPokemonsPageUseCase())
    {
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
    }

    // MARK: - Methods

    func fetchPokemonsPage(_ page: Page) async
    {
        await resetViewModel()
        do
        {
            let page = try await fetchPokemonsUseCase.execute(page.toDomain())
            await MainActor.run
            {
                setupNewCurrentPage(page)
            }
        }
        catch
        {
            errorMessage = error.localizedDescription
        }
    }
}

extension PokemonListViewModel
{
    private func resetViewModel() async
    {
        await MainActor.run
        {
            errorMessage = ""
        }
    }

    @MainActor private func setupNewCurrentPage(_ page: PokemonPage)
    {
        currentPage = page
        listOfPokemons = page.list.map { $0.name }
        nextPageDisabled = page.nextPagePath == nil
        previousPageDisabled = page.previousPagePath == nil
    }
}
