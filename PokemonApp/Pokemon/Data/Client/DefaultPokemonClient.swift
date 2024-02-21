import Foundation

final class DefaultPokemonClient: PokemonClient
{
    private let networkService: NetworkService

    init(networkService: NetworkService = DefaultNetworkService())
    {
        self.networkService = networkService
    }

    func getPokemonList(page: Page) async throws -> PokemonPage
    {
        let endpoint: ApiEndpoint = .page(number: page.number)
        do
        {
            let response: PokemonPageDataModel = try await networkService.request(to: endpoint)
            let page = response.toDomain()
            return page
        }
        catch
        {
            throw mapToClientError(error)
        }
    }
}

extension DefaultPokemonClient
{
    private func mapToClientError(_ error: Error) -> ClientError
    {
        guard let error = error as? NetworkError else { return .unknown(error) }
        return ClientError.networkError(error)
    }
}
