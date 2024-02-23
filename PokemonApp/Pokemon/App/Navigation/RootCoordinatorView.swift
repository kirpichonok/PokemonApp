import SwiftUI

struct CoordinatorRootView: View
{
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View
    {
        NavigationStack(path: $coordinator.path)
        {
            coordinator.build(.pokemonList)
                .navigationDestination(for: DestinationScreen.self)
                { destination in
                    coordinator.build(destination)
                }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview
{
    CoordinatorRootView().environmentObject(AppCoordinator())
}
