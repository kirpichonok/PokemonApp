import SwiftUI

struct CoordinatorRootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var launchScreenManager: LaunchScreenManager

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                coordinator.build(.pokemonList)
                    .navigationDestination(for: DestinationScreen.self) { destination in
                        coordinator.build(destination)
                    }

                if launchScreenManager.state != .completed {
                    LaunchScreenView()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            launchScreenManager.dismiss()
        }
    }
}

#Preview {
    CoordinatorRootView()
        .environmentObject(AppCoordinator())
        .environmentObject(LaunchScreenManager())
}
