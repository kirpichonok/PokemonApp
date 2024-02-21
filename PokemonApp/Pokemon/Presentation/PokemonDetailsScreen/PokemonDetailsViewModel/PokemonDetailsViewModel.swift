import Foundation

final class PokemonDetailsViewModel: ObservableObject
{
    @Published private(set) var pokemonDescription = PokemonDescriptionViewModel()
    @Published private(set) var imageData: Data?
    @Published private(set) var requestState: RequestState = .success

    private let fetchPokemonDetailsUseCase: FetchPokemonDetailsUseCase
    private let pokemonPreview: PokemonPreview
    private var currentTask: Task<Void, Error>?
    {
        willSet { currentTask?.cancel() }
    }

    init(
        pokemonPreview: PokemonPreview,
        fetchPokemonDetailsUseCase: FetchPokemonDetailsUseCase = FetchPokemonDetailsUseCase()
    )
    {
        self.pokemonPreview = pokemonPreview
        self.fetchPokemonDetailsUseCase = fetchPokemonDetailsUseCase
        Task { await fetchPokemonDetails() }
    }

    @MainActor private func fetchPokemonDetails() async
    {
        await MainActor.run { requestState = .isLoading }
        do
        {
            let pokemon = try await fetchPokemonDetailsUseCase.fetchPokemonDetails(for: pokemonPreview)
            var imageData: Data?

            if let imagePath = pokemon.imagePath,
               let url = URL(string: imagePath)
            {
                let (data, _) = try await URLSession.shared.data(from: url)
                imageData = data
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