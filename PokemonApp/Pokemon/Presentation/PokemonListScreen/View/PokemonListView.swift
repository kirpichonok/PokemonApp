import SwiftUI

struct PokemonListView: View
{
    @ObservedObject var viewModel: PokemonListViewModel

    var body: some View
    {
        if !viewModel.isErrorOccurred
        {
            List(viewModel.listOfPokemons, id: \.self)
            {
                Text($0)
            }
            .task
            {
                await viewModel.fetchPokemonsPage()
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
                    Task { viewModel.fetchPokemonsPage }
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

    init(viewModel: PokemonListViewModel)
    {
        self.viewModel = viewModel
    }
}

#Preview
{
    PokemonListView(viewModel: PokemonListViewModel())
}
