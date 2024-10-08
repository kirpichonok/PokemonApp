import Foundation

final class DefaultPokemonClient: PokemonClient {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getPokemonList(page: Page) async throws -> PokemonPage {
        let endpoint: ApiEndpoint = .page(number: page.number)
        do {
            let response: PokemonPageDataModel = try await networkService.request(to: endpoint)
            let page = response.toDomain()
            return page
        } catch {
            throw error.convertToClientError()
        }
    }
}
