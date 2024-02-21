import Foundation

final class PokemonListViewModel: ObservableObject
{
    // MARK: - Properties

    @Published private(set) var listOfPokemons = [String]()
    @Published private(set) var nextPageDisabled = true
    @Published private(set) var previousPageDisabled = true
    @Published private(set) var requestState: RequestState = .success
    @Published private(set) var currentPageNumber = 0
    @Published private(set) var numberOfPages = 0

    // MARK: - Private properties

    private let fetchPokemonsUseCase: FetchPokemonsPageUseCase
    private var currentPage: PokemonPage?
    {
        didSet
        { Task { await updateCorrespondingNewPage() }}
    }

    init(fetchPokemonsUseCase: FetchPokemonsPageUseCase = FetchPokemonsPageUseCase())
    {
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
    }

    // MARK: - Methods

    func fetchPokemonsPage(_ page: PageToPresent) async
    {
        await MainActor.run { requestState = .isLoading }
        let newPageNumber: Int

        switch page
        {
        case .initial:
            newPageNumber = .zero
        case .next:
            newPageNumber = currentPageNumber + 1
        case .previous:
            newPageNumber = currentPageNumber - 1
        }

        await fetchPokemonsPage(number: newPageNumber)
    }

    func reload() async
    {
        await fetchPokemonsPage(number: currentPageNumber)
    }
}

extension PokemonListViewModel
{
    private func fetchPokemonsPage(number: Int) async
    {
        do
        {
            currentPage = try await fetchPokemonsUseCase.fetchPokemonList(page: .init(number: number))
            await MainActor.run { currentPageNumber = number }
        }
        catch
        {
            requestState = .failed(withError: error)
        }
    }

    @MainActor private func updateCorrespondingNewPage() async
    {
        requestState = .success
        if let currentPage
        {
            listOfPokemons = currentPage.list.map { $0.name.capitalized }

            calculateNumberOfPages(totalCount: currentPage.totalCount)

            nextPageDisabled = currentPageNumber >= numberOfPages
            previousPageDisabled = currentPageNumber <= .zero
        }
        else {
            numberOfPages = .zero
            currentPageNumber = .zero
            nextPageDisabled = false
            previousPageDisabled = false
        }
    }

    private func calculateNumberOfPages(totalCount: Int)
    {
        let devisionResult = (Double(totalCount) / Double(PokemonPage.pageCapacity))
        numberOfPages = Int(ceil(devisionResult))
    }
}
