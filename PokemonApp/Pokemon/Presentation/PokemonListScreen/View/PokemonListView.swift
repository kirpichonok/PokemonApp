import SwiftUI

struct PokemonListView: View
{
    @ObservedObject var viewModel: PokemonListViewModel

    var body: some View
    {
        ZStack
        {
            if !viewModel.isErrorOccurred
            {
                List(viewModel.listOfPokemons, id: \.self)
                {
                    Text($0)
                }
                .task
                {
                    await viewModel.fetchPokemonsPage(.initial)
                }
            }

            else
            {
                VStack(spacing: 20)
                {
                    Text(viewModel.errorMessage)
                        .font(.system(.title3))
                    Button
                    {
                        Task { await viewModel.fetchPokemonsPage(.initial) }
                    }
                    label:
                    {
                        Image(systemName: .SystemImageName.arrowClockwiseCircle)
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
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
