import SwiftUI

struct CoordinatorRootView: View
{
    @EnvironmentObject private var coordinator: Coordinator

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
    CoordinatorRootView().environmentObject(Coordinator())
}
