import Alamofire
import Foundation

extension AFError
{
    func convertToNetworkError() -> NetworkError
    {
        let connectionFailureStatusCodes = [
            URLError.notConnectedToInternet,
            URLError.networkConnectionLost,
            URLError.cannotConnectToHost,
        ]

        let networkError: NetworkError
        switch self
        {
        case .invalidURL:
            networkError = .invalidUrl

        case let .sessionTaskFailed(error as URLError)
            where connectionFailureStatusCodes.contains(error.code):
            networkError = .connectionFailed

        case .sessionTaskFailed(URLError.timedOut):
            networkError = .timedOut

        default:
            networkError = .requestFailed(statusCode: responseCode ?? 418)
        }

        return networkError
    }
}
