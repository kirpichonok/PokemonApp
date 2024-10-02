import Foundation

protocol PokemonImageStorage {
    func getImage(for path: String) async throws -> Data?

    func save(data: Data, for path: String)
}
