import Alamofire
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
            let response = try await moyaProvider.request(endpoint)
                .filterSuccessfulStatusCodes()

            if T.self is Data.Type,
               let data = response.data as? T
            {
                return data
            }
            else
            {
                return try response.map(T.self, using: endpoint.responseDecoder)
            }
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
        if let error = error as? AFError
        {
            return error.convertToNetworkError()
        }
        else
        {
            return error.convertToNetworkError()
        }
    }
}
