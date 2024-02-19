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

    // MARK: - Private properties

    private let fetchPokemonsUseCase: FetchPokemonsPageUseCase
    private var currentPage: PokemonPage?
    {
        didSet
        {
            guard let currentPage else { return }
            Task
            {
                await MainActor.run
                {
                    listOfPokemons = currentPage.list.map { $0.name }
                }
            }
        }
    }

    init(fetchPokemonsUseCase: FetchPokemonsPageUseCase = FetchPokemonsPageUseCase())
    {
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
    }

    // MARK: - Methods

    func fetchPokemonsPage() async
    {
        await resetViewModel()

        do
        {
            let page = try await fetchPokemonsUseCase.execute(with: .initialPage)
            await MainActor.run
            {
                currentPage = page
            }
        }
        catch
        {
            errorMessage = error.localizedDescription
        }
    }

    private func resetViewModel() async
    {
        await MainActor.run
        {
            errorMessage = ""
        }
    }
}
