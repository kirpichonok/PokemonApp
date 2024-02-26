import Foundation

final class PokemonListViewModel: ObservableObject
{
    // MARK: - Properties

    @Published private(set) var pageViewModel = PageViewModel.empty
    @Published private(set) var requestState: RequestState = .success

    // MARK: - Private properties

    private let fetchPokemonsUseCase: FetchPokemonsPageUseCase
    private weak var coordinator: (any Coordinator)?
    private var currentPage: PokemonPage?

    @MainActor
    private(set) var currentTask: [Int: Task<Void, Never>] = [:]

    init(
        fetchPokemonsUseCase: FetchPokemonsPageUseCase,
        coordinator: (any Coordinator)?
    )
    {
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
        self.coordinator = coordinator
        Task
        { await switchTo(page: .initial) }
    }

    // MARK: - Methods

    func switchTo(page: PageToPresent) async
    {
        let newPageNumber = switch page
        {
        case .initial: 1
        case .next: pageViewModel.currentPageNumber + 1
        case .previous: pageViewModel.currentPageNumber - 1
        }

        await loadPage(pageNumber: newPageNumber)
    }

    func reload() async
    {
        await loadPage(pageNumber: pageViewModel.currentPageNumber)
    }

    func didSelectRow(index: Int)
    {
        guard let currentPage, !currentPage.list.isEmpty else { return }
        let pokemonPreview = currentPage.list[index]
        coordinator?.push(destination: .detailView(of: pokemonPreview))
    }
}

extension PokemonListViewModel
{
    @MainActor private func loadPage(pageNumber: Int) async
    {
        guard pageNumber > 0 else { return }

        guard currentTask[pageNumber] == nil
        else
        {
            await currentTask[pageNumber]?.value
            return
        }

        currentTask[pageNumber] = Task
        {
            defer { currentTask[pageNumber] = nil }
            requestState = .isLoading
            do
            {
                let newPokemonPage = try await fetchPokemonsUseCase.fetchPokemonList(
                    page: .init(number: pageNumber)
                )
                if !Task.isCancelled
                {
                    pageViewModel = .init(pokemonPage: newPokemonPage, currentPageNumber: pageNumber)
                    currentPage = newPokemonPage
                    requestState = .success
                }
            }
            catch
            {
                if !Task.isCancelled
                {
                    requestState = .failed(withError: error)
                }
            }
        }
        
        await currentTask[pageNumber]?.value
    }
}
