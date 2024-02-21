import SwiftUI

struct PokemonListView: View
{
    @ObservedObject var viewModel: PokemonListViewModel

    var body: some View
    {
        ZStack
        {
            List(viewModel.listOfPokemons, id: \.self)
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
                HStack(spacing: 40)
                {
                    Button
                    {
                        Task
                        { await viewModel.fetchPokemonsPage(.previous) }
                    }
                    label:
                    {
                        Image(systemName: .SystemImageName.chevronBackwardSquare)
                    }
                    .allowsHitTesting(!viewModel.previousPageDisabled)

                    Button
                    {
                        Task
                        { await viewModel.fetchPokemonsPage(.next) }
                    }
                    label:
                    {
                        Image(systemName: .SystemImageName.chevronForwardSquare)
                    }
                    .allowsHitTesting(!viewModel.nextPageDisabled)
                }
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
