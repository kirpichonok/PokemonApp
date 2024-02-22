import SwiftUI

struct PokemonListView: View
{
    @StateObject var viewModel: PokemonListViewModel

    var body: some View
    {
        ZStack
        {
            List(
                viewModel.pageViewModel.listOfPokemons.indices,
                id: \.self
            )
            { index in
                Button
                {
                    viewModel.didSelectRow(index: index)
                }
                label: {
                    Text(viewModel.pageViewModel.listOfPokemons[index])
                        .tint(.primary)
                }
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
        .navigationTitle("Pokemons")
        .toolbar
        {
            ToolbarItemGroup(placement: .bottomBar)
            {
                SwitchPageView(
                    pageViewModel: viewModel.pageViewModel,
                    backAction: {
                        viewModel.fetchPokemonsPage(.previous)
                    },
                    nextAction: {
                        viewModel.fetchPokemonsPage(.next)
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
        let viewModel = AppDIContainer().makePokemonListViewModel(with: nil)
        return PokemonListView(viewModel:viewModel)
        
    }
}
