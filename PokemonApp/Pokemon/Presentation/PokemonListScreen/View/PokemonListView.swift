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
                progressView
            }
        }
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
    
    // MARK: - Private properties

    private var progressView: some View
    {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2)
            .tint(.accentColor)
    }
}

#Preview
{
    NavigationStack
    {
        PokemonListView(viewModel: PokemonListViewModel())
    }
}
