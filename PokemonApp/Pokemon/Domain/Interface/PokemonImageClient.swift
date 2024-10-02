import Foundation

protocol PokemonImageClient {
    func getImage(with path: String) async throws -> Data
}
