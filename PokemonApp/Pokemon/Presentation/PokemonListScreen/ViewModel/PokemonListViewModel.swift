import Foundation

final class PokemonListViewModel: ObservableObject
{
    // MARK: - Properties

    @Published private(set) var pageViewModel = PageViewModel.empty
    @Published private(set) var requestState: RequestState = .success

    // MARK: - Private properties

    private let fetchPokemonsUseCase: FetchPokemonsPageUseCase
    private weak var coordinator: Coordinator?
    private var currentPage: PokemonPage?
    private var currentTask: Task<Void, Error>?
    {
        willSet { currentTask?.cancel() }
    }

    init(
        fetchPokemonsUseCase: FetchPokemonsPageUseCase,
        coordinator: Coordinator?
    )
    {
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
        self.coordinator = coordinator
    }

    // MARK: - Methods

    func fetchPokemonsPage(_ page: PageToPresent) async
    {
        await MainActor.run { requestState = .isLoading }
        let newPageNumber: Int

        switch page
        {
        case .initial:
            newPageNumber = 1
        case .next:
            newPageNumber = pageViewModel.currentPageNumber + 1
        case .previous:
            newPageNumber = pageViewModel.currentPageNumber - 1
        }

        await fetchPokemonsPage(number: newPageNumber)
    }

    func reload() async
    {
        await fetchPokemonsPage(number: pageViewModel.currentPageNumber)
    }
    
    func didSelectRow(index: Int) {
        if let pokemonPreview = currentPage?.list[index] {
            coordinator?.push(destination: .detailView(of: pokemonPreview))
        }
    }
}

extension PokemonListViewModel
{
    private func fetchPokemonsPage(number: Int) async
    {
        currentTask = Task
        {
            defer { currentTask = nil }
            do
            {
                let newPokemonPage = try await fetchPokemonsUseCase.fetchPokemonList(page: .init(number: number))
                currentPage = newPokemonPage
                await MainActor.run
                {
                    pageViewModel = .init(pokemonPage: newPokemonPage, currentPageNumber: number)
                    requestState = .success
                }
            }
            catch
            {
                await MainActor.run
                {
                    requestState = .failed(withError: error)
                }
            }
        }
    }
}
