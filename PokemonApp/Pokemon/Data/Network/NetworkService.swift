import Foundation

protocol NetworkService {
    func request<T: Decodable>(to endpoint: ApiEndpoint) async throws -> T
}
