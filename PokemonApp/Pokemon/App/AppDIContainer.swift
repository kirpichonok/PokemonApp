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

    func makePokemonListViewModel<C: Coordinator>(with coordinator: C) -> PokemonListView.ViewModel<DefaultFetchPokemonsPageUseCase,C> {
        .init(fetchPokemonsUseCase: makeFetchPokemonsPageUseCase(),
              coordinator: coordinator)
    }

    // MARK: - Use Cases

    private func makeFetchPokemonDetailsUseCase() -> FetchPokemonDetailsUseCase {
        DefaultFetchPokemonDetailsUseCase(
            pokemonDetailsClient: makePokemonDetailsClient(),
            pokemonImageClient: makePokemonImageClient()
        )
    }

    private func makeFetchPokemonsPageUseCase() -> DefaultFetchPokemonsPageUseCase {
        DefaultFetchPokemonsPageUseCase(pokemonClient: makePokemonClient())
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
