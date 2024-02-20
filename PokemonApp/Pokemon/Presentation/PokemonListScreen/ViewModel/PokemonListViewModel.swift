import Foundation

final class PokemonListViewModel: ObservableObject
{
    // MARK: - Properties

    @MainActor
    @Published private(set) var listOfPokemons = [String]()
    @MainActor
    @Published private(set) var nextPageDisabled = true
    @MainActor
    @Published private(set) var previousPageDisabled = true
    @MainActor
    @Published private(set) var requestState: RequestState = .success

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
        await MainActor.run
        {
            requestState = .isLoading
        }

        do
        {
            let page = try await fetchPokemonsUseCase.execute(page.toDomain())
            await setupNewCurrentPage(page)
        }
        catch
        {
            await MainActor.run
            {
                requestState = .failed(withError: error)
            }
        }
    }

    func reload()
    {
        Task { await fetchPokemonsPage(.initial) }
    }
}

extension PokemonListViewModel
{
    @MainActor private func setupNewCurrentPage(_ page: PokemonPage) async
    {
        requestState = .success
        currentPage = page
        listOfPokemons = page.list.map { $0.name }
        nextPageDisabled = page.nextPagePath == nil
        previousPageDisabled = page.previousPagePath == nil
    }
}
