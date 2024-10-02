import Foundation

final class CoordinatorMock: Coordinator {
    var pushCalled = false
    var destination: DestinationScreen?

    func push(destination: DestinationScreen) {
        pushCalled = true
        self.destination = destination
    }

    func build(_: DestinationScreen) {}
    func pop() {}
    func popToRoot() {}
}
