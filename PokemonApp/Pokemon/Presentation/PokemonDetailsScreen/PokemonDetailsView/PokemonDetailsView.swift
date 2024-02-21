import SwiftUI

struct PokemonDetailsView: View
{
    @StateObject var viewModel: PokemonDetailsViewModel
    @Environment (\.dismiss) var dismiss

    var body: some View
    {
        ZStack
        {
            VStack
            {
                VStack
                {
                    Text(viewModel.pokemonDescription.name)
                        .font(.system(.largeTitle, design: .rounded, weight: .semibold))

                    Image(data: viewModel.imageData)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .shadow(color: .primary, radius: 30)
                }

                List
                {
                    Section
                    {
                        Text("Type: " + viewModel.pokemonDescription.type)
                        Text("Weight: " + viewModel.pokemonDescription.weight)
                        Text("Height: " + viewModel.pokemonDescription.height)
                    }
                    header:
                    {
                        Label(
                            title:
                            {
                                Text("Information")
                                    .font(.body)
                                    .foregroundStyle(.primary)

                            },
                            icon:
                            {
                                Image(systemName: .SystemImageName.infoSquare)
                                    .font(.body)
                            }
                        )
                    }
                }
                .scrollContentBackground(.hidden)
                .disabled(true)
            }

            if case let .failed(withError: error) = viewModel.requestState
            {
                ErrorView(
                    error: error,
                    reloadAction: { dismiss() }
                )
            }

            else if case .isLoading = viewModel.requestState
            {
                AppProgressView()
            }
        }
    }
}

#Preview
{
    NavigationStack
    {
        PokemonDetailsView(
            viewModel: PokemonDetailsViewModel(
                pokemonPreview: PokemonPreview(
                    name: "Pika",
                    pathToDetails: "https://pokeapi.co/api/v2/pokemon/13/"
                )
            )
        )
    }
}
