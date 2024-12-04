import SwiftUI

final class AppCoordinator: ObservableObject, Coordinator {
    @Published var path = NavigationPath()

    private let appDiContainer = AppDIContainer()

    // MARK: - Methods

    func push(destination: DestinationScreen) {
        path.append(destination)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    @ViewBuilder func build(_ destination: DestinationScreen) -> some View {
        switch destination {
        case .pokemonList:
            PokemonListView(
                useCase:  appDiContainer.makeFetchPokemonsPageUseCase,
                coordinator: self
            )

        case let .detailView(of: pokemonPreview):
            let viewModel = appDiContainer.makePokemonDetailsViewModel(
                with: pokemonPreview,
                coordinator: self
            )
            PokemonDetailsView(viewModel: viewModel)
        }
    }
}
