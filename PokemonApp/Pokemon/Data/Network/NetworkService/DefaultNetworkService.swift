import Foundation
import Moya

final class DefaultNetworkService: NetworkService
{
    // MARK: - Private properties

    private let moyaProvider = MoyaProvider<ApiEndpoint>()

    // MARK: - Methods

    func request<T>(to endpoint: ApiEndpoint) async throws -> T where T: Decodable
    {
        do
        {
            return try await moyaProvider.request(endpoint)
                .filterSuccessfulStatusCodes()
                .map(T.self, using: endpoint.responseDecoder)
        }
        catch
        {
            throw mapToNetworkError(error)
        }
    }

    // MARK: - Private methods

    private func mapToNetworkError(_ error: Error) -> NetworkError
    {
        guard let moyaError = error as? MoyaError else { return .unknown(error) }

        switch moyaError
        {
        case let .objectMapping(error, _):
            return .parsingFailed(error)

        case .requestMapping, .parameterEncoding:
            return .invalidUrl

        case let .statusCode(response):
            return .requestFailed(statusCode: response.statusCode)

        case let .underlying(underlyingError, _):
            return mapUnderlyingError(underlyingError)

        default:
            return .unknown(error)
        }
    }

    private func mapUnderlyingError(_ error: Error) -> NetworkError
    {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code
        {
        case .notConnectedToInternet, .networkConnectionLost, .cannotConnectToHost:
            return .connectionFailed
        case .timedOut:
            return .timedOut
        default:
            return .unknown(error)
        }
    }
}