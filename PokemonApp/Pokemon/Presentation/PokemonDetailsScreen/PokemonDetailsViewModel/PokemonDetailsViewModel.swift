import Foundation

final class PokemonDetailsViewModel: ObservableObject
{
    @Published private(set) var pokemonDescription = PokemonDescriptionViewModel()
    @Published private(set) var imageData: Data?
    @Published private(set) var requestState: RequestState = .success

    private let fetchPokemonDetailsUseCase: FetchPokemonDetailsUseCase
    private weak var coordinator: (any Coordinator)?
    private let pokemonPreview: PokemonPreview
    private var pokemon: Pokemon?
    {
        didSet
        {
            if let pokemon
            {
                pokemonDescription = .init(pokemon: pokemon)
                currentTask = Task { await fetchImage() }
            }
        }
    }

    private var currentTask: Task<Void, Error>?
    {
        willSet { currentTask?.cancel() }
    }

    init(
        pokemonPreview: PokemonPreview,
        fetchPokemonDetailsUseCase: FetchPokemonDetailsUseCase,
        coordinator: (any Coordinator)?
    )
    {
        self.pokemonPreview = pokemonPreview
        self.fetchPokemonDetailsUseCase = fetchPokemonDetailsUseCase
        self.coordinator = coordinator
        currentTask = Task { await fetchPokemonDetails() }
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
        requestState = .isLoading
        do
        {
            let pokemon = try await fetchPokemonDetailsUseCase.fetchPokemonDetails(for: pokemonPreview)
            if !Task.isCancelled
            {
                requestState = .success
                self.pokemon = pokemon
            }
        }
        catch
        {
            requestState = .failed(withError: error)
        }
    }

    @MainActor private func fetchImage() async
    {
        if let imagePath = pokemon?.imagePath
        {
            imageData = try? await fetchPokemonDetailsUseCase.fetchPokemonImage(with: imagePath)

            if let imageData, !Task.isCancelled
            {
                self.imageData = imageData
                requestState = .success
                currentTask = nil
            }
        }
    }
}
