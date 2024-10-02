import Foundation

final class LaunchScreenManager: ObservableObject {
    @Published private(set) var state: LaunchScreenState = .firstPhase

    let timer = Timer
        .publish(every: 0.7, on: .main, in: .common)
        .autoconnect()
    
    @MainActor func dismiss() {
        state = .secondPhase
        Task {
            try? await Task.sleep(until: .now + .seconds(1))
            state = .completed
        }
    }
}

extension LaunchScreenManager {
    enum LaunchScreenState {
        case firstPhase
        case secondPhase
        case completed
    }
}
