import Foundation

final class DefaultPokemonClient: PokemonClient
{
    private let networkService: NetworkService
    private var currentPage: PokemonPage?

    init(networkService: NetworkService = DefaultNetworkService())
    {
        self.networkService = networkService
    }

    func getPokemonPage(_ page: Page) async throws -> PokemonPage
    {
        let endpoint: ApiEndpoint

        switch page
        {
        case .initial:
            endpoint = .initialPage
        case .next:
            guard let nextPagePath = currentPage?.nextPagePath,
                  let url = URL(string: nextPagePath) else { throw ClientError.invalidUrl }
            endpoint = .resource(url: url)
        case .previous:
            guard let previousPagePath = currentPage?.previousPagePath,
                  let url = URL(string: previousPagePath) else { throw ClientError.invalidUrl }
            endpoint = .resource(url: url)
        }

        do
        {
            let response: PokemonPageDataModel = try await networkService.request(to: endpoint)
            let page = response.toDomain()
            currentPage = page
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
        guard let error = error as? NetworkError else  { return .unknown(error)}
        return ClientError.networkError(error)
    }
}
