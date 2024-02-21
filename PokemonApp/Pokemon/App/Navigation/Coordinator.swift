import SwiftUI

final class Coordinator: ObservableObject
{
    @Published var path = NavigationPath()

    // MARK: - Methods

    func push(destination: DestinationScreen)
    {
        path.append(destination)
    }

    func pop()
    {
        path.removeLast()
    }

    func popToRoot()
    {
        path.removeLast(path.count)
    }

    @ViewBuilder func build(_ destination: DestinationScreen) -> some View
    {
        switch destination
        {
        case .pokemonList:
            let viewModel = makePokemonListViewModel()
            PokemonListView(viewModel: viewModel)

        case let .detailView(of: pokemonPreview):
            let viewModel = makePokemonDetailsViewModel(with: pokemonPreview)
            PokemonDetailsView(viewModel: viewModel)
        }
    }
}

extension Coordinator
{
    // MARK: - Private methods

    private func makePokemonDetailsViewModel(with pokemonPreview: PokemonPreview) -> PokemonDetailsViewModel
    {
        .init(pokemonPreview: pokemonPreview,
              fetchPokemonDetailsUseCase: FetchPokemonDetailsUseCase(),
              coordinator: self)
    }

    private func makePokemonListViewModel() -> PokemonListViewModel
    {
        .init(fetchPokemonsUseCase: FetchPokemonsPageUseCase(),
              coordinator: self)
    }
}
