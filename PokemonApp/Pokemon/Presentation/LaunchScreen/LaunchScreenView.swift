import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject var screenManager: LaunchScreenManager

    var body: some View {
        ZStack {
            Image(.pokemons)
                .ignoresSafeArea()
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .rotationEffect(.degrees(rotationAngle))
                .scaleEffect(isScaled ? screenHeight / 4 : 1)
                .onReceive(timer) { _ in
                    iterationCounter += 1
                    withAnimation(.linear(duration: 0.7)) {
                        rotationAngle += iterationCounter * 360
                    }
                }
                .onReceive(screenManager.$state) { state in
                    if state == .secondPhase {
                        withAnimation(.easeInOut) {
                            isScaled.toggle()
                        }
                    }
                }
        }
    }

    @State private var isScaled = false
    @State private var rotationAngle: Double = 0
    @State private var iterationCounter: Double = 0
    private let screenHeight = (UIApplication.shared.connectedScenes.first as! UIWindowScene)
        .screen.nativeBounds.size.height
    private let timer = Timer
        .publish(every: 0.6, on: .main, in: .common)
        .autoconnect()
}

#Preview {
    LaunchScreenView()
        .environmentObject(LaunchScreenManager())
}
