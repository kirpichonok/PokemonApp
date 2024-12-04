import Foundation

final class AppDIContainer {
    private lazy var defaultNetworkService = DefaultNetworkService()

    // MARK: - View Models

    func makePokemonDetailsViewModel(
        with pokemonPreview: PokemonPreview,
        coordinator: (any Coordinator)?
    ) -> PokemonDetailsViewModel {
        .init(pokemonPreview: pokemonPreview,
              fetchPokemonDetailsUseCase: makeFetchPokemonDetailsUseCase(),
              coordinator: coordinator)
    }

    func makeFetchPokemonsPageUseCase() -> DefaultFetchPokemonsPageUseCase {
        DefaultFetchPokemonsPageUseCase(pokemonClient: makePokemonClient())
    }

    // MARK: - Use Cases

    private func makeFetchPokemonDetailsUseCase() -> FetchPokemonDetailsUseCase {
        DefaultFetchPokemonDetailsUseCase(
            pokemonDetailsClient: makePokemonDetailsClient(),
            pokemonImageClient: makePokemonImageClient()
        )
    }

    // MARK: - Client

    private func makePokemonDetailsClient() -> PokemonDetailsClient {
        DefaultPokemonDetailsClient(networkService: defaultNetworkService)
    }

    private func makePokemonClient() -> PokemonClient {
        DefaultPokemonClient(networkService: defaultNetworkService)
    }

    private func makePokemonImageClient() -> PokemonImageClient {
        DefaultPokemonImageClient(
            networkService: defaultNetworkService,
            imageStorage: CoreDataPokemonImageStorage()
        )
    }
}
