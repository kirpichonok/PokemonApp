import Foundation

final class PokemonListViewModel: ObservableObject
{
    // MARK: - Properties

    @Published private(set) var listOfPokemons = [String]()
    @Published private(set) var requestState: RequestState = .success
    @Published private(set) var currentPageNumber = 1
    @Published private(set) var numberOfPages = 1
    var nextPageDisabled: Bool
    {
        currentPageNumber >= numberOfPages
    }

    var previousPageDisabled: Bool
    {
        currentPageNumber <= 1
    }

    // MARK: - Private properties

    private let fetchPokemonsUseCase: FetchPokemonsPageUseCase
    private weak var coordinator: (any Coordinator)?
    private var currentPage: PokemonPage?
    {
        didSet
        {
            if let currentPage
            {
                listOfPokemons = currentPage.list.map { $0.name.capitalized }
                calculateNumberOfPages(totalCount: currentPage.totalCount)
            }
        }
    }

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
        case .next: currentPageNumber + 1
        case .previous: currentPageNumber - 1
        }

        await loadPage(pageNumber: newPageNumber)
    }

    func reload() async
    {
        await loadPage(pageNumber: currentPageNumber)
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
                    currentPageNumber = pageNumber
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

    private func calculateNumberOfPages(totalCount: Int)
    {
        let devisionResult = (Double(totalCount) / Double(PokemonPage.pageCapacity))
        numberOfPages = Int(ceil(devisionResult))
    }
}
