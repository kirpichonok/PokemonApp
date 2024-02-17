import SwiftUI

struct PokemonListView: View {
    @ObservedObject var viewModel: PokemonListViewModel
    
    var body: some View {
        List(viewModel.listOfPokemons, id: \.self) {
            Text($0)
        }
    }
}

#Preview {
    PokemonListView(viewModel: PokemonListViewModel())
}
