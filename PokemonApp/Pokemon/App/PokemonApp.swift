import SwiftUI

@main
struct PokemonApp: App
{
    var body: some Scene
    {
        WindowGroup
        {
            PokemonListView(viewModel: PokemonListViewModel())
        }
    }
}
