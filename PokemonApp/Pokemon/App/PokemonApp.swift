import SwiftUI

@main
struct PokemonApp: App
{
    var body: some Scene
    {
        WindowGroup
        {
            CoordinatorRootView()
                .environmentObject(AppCoordinator())
        }
    }
}
