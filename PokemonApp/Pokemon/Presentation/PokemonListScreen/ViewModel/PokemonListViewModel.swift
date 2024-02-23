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
    private(set) var currentTask: Task<Void, Never>?
    {
        willSet { currentTask?.cancel() }
    }

    init(
        fetchPokemonsUseCase: FetchPokemonsPageUseCase,
        coordinator: (any Coordinator)?
    )
    {
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
        self.coordinator = coordinator
        currentTask = Task
        { await fetchPokemonsPage(number: pageViewModel.currentPageNumber) }
    }

    // MARK: - Methods

    func fetchPokemonsPage(_ page: PageToPresent) async
    {
        let newPageNumber = switch page
        {
        case .initial: 1
        case .next: pageViewModel.currentPageNumber + 1
        case .previous: pageViewModel.currentPageNumber - 1
        }

        guard newPageNumber > 0 else { return }
        currentTask = Task
        { await fetchPokemonsPage(number: newPageNumber) }
        await currentTask?.value
    }

    func reload() async
    {
        currentTask = Task
        { await fetchPokemonsPage(number: pageViewModel.currentPageNumber) }
        await currentTask?.value
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
    @MainActor private func fetchPokemonsPage(number: Int) async
    {
        requestState = .isLoading
        do
        {
            let newPokemonPage = try await fetchPokemonsUseCase.fetchPokemonList(page: .init(number: number))

            if !Task.isCancelled
            {
                currentPage = newPokemonPage
                pageViewModel = .init(pokemonPage: newPokemonPage, currentPageNumber: number)
                requestState = .success
                currentTask = nil
            }
        }
        catch
        {
            if !Task.isCancelled
            {
                requestState = .failed(withError: error)
                currentTask = nil
            }
        }
    }
}
