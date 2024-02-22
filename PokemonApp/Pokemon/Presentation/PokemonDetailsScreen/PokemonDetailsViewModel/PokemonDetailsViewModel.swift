import Foundation

final class PokemonDetailsViewModel: ObservableObject
{
    @Published private(set) var pokemonDescription = PokemonDescriptionViewModel()
    @Published private(set) var imageData: Data?
    @Published private(set) var requestState: RequestState = .success

    private let fetchPokemonDetailsUseCase: FetchPokemonDetailsUseCase
    private weak var coordinator: Coordinator?
    private let pokemonPreview: PokemonPreview
    private var currentTask: Task<Void, Error>?
    {
        willSet { currentTask?.cancel() }
    }

    init(
        pokemonPreview: PokemonPreview,
        fetchPokemonDetailsUseCase: FetchPokemonDetailsUseCase,
        coordinator: Coordinator?
    )
    {
        self.pokemonPreview = pokemonPreview
        self.fetchPokemonDetailsUseCase = fetchPokemonDetailsUseCase
        self.coordinator = coordinator
        Task { await fetchPokemonDetails() }
    }
    
    func didBackButtonPressed()
    {
        currentTask?.cancel()
        coordinator?.pop()
    }
}

extension PokemonDetailsViewModel
{
    @MainActor private func fetchPokemonDetails() async
    {
        await MainActor.run { requestState = .isLoading }
        do
        {
            let pokemon = try await fetchPokemonDetailsUseCase.fetchPokemonDetails(for: pokemonPreview)
            var imageData: Data?

            if let imagePath = pokemon.imagePath
            {
                imageData = try await fetchPokemonDetailsUseCase.fetchPokemonImage(with: imagePath)
            }

            await MainActor.run
            {
                self.imageData = imageData
                pokemonDescription = .init(pokemon: pokemon)
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
