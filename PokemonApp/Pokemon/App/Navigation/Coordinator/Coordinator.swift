import Foundation

protocol Coordinator: AnyObject {
    associatedtype Content
    func push(destination: DestinationScreen)
    func pop()
    func popToRoot()
    func build(_ destination: DestinationScreen) -> Content
}
