import SwiftUI

struct PokemonListView: View
{
    @StateObject var viewModel: PokemonListViewModel

    var body: some View
    {
        NavigationStack
        {
            ZStack
            {
                List(viewModel.pageViewModel.listOfPokemons, id: \.self)
                { name in
                    NavigationLink(
                        name,
                        value: viewModel.currentPage?.list.first
                        { $0.name.lowercased() == name.lowercased() }
                    )
                }
                .navigationDestination(for: PokemonPreview.self)
                { pokemonPreview in
                    PokemonDetailsView(
                        viewModel: PokemonDetailsViewModel(
                            pokemonPreview: pokemonPreview
                        )
                    )
                }
                .disabled(viewModel.requestState != .success)
                .blur(radius: viewModel.requestState == .success ? 0 : 4)

                if case let .failed(withError: error) = viewModel.requestState
                {
                    ErrorView(
                        error: error,
                        reloadAction: { Task { await viewModel.reload() } }
                    )
                }

                else if case .isLoading = viewModel.requestState
                {
                    AppProgressView()
                }
            }
        }
        .navigationTitle("Pokemons")
        .task { await viewModel.fetchPokemonsPage(.initial) }
        .toolbar
        {
            ToolbarItemGroup(placement: .bottomBar)
            {
                SwitchPageView(
                    pageViewModel: viewModel.pageViewModel,
                    backAction: {
                        Task
                        { await viewModel.fetchPokemonsPage(.previous) }
                    },
                    nextAction: {
                        Task
                        { await viewModel.fetchPokemonsPage(.next) }
                    }
                )
            }
        }
    }
}

#Preview
{
    NavigationStack
    {
        PokemonListView(viewModel: PokemonListViewModel())
    }
}
