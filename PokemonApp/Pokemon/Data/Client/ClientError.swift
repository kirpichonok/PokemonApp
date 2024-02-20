import Foundation

enum ClientError
{
    case invalidUrl
    case networkError(NetworkError)
    case unknown(Error)
}

extension ClientError: LocalizedError
{
    var errorDescription: String?
    {
        switch self
        {
        case .invalidUrl:
            return "Invalid URL address is received."
        case let .networkError(networkError):
            return networkError.localizedDescription
        case let .unknown(error):
            return "Internal error: \(error.localizedDescription)."
        }
    }
}
