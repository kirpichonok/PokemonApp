import SwiftUI

struct PokemonListView: View
{
    @ObservedObject var viewModel: PokemonListViewModel

    var body: some View
    {
        ZStack
        {
            List(viewModel.pageViewModel.listOfPokemons, id: \.self)
            {
                Text($0)
            }
            .task
            {
                await viewModel.fetchPokemonsPage(.initial)
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
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(2)
                    .tint(.accentColor)
            }
        }
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

    init(viewModel: PokemonListViewModel)
    {
        self.viewModel = viewModel
    }
}

#Preview
{
    NavigationStack
    {
        PokemonListView(viewModel: PokemonListViewModel())
    }
}
