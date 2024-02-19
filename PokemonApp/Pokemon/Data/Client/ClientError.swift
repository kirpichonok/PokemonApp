import Foundation

enum ClientError: LocalizedError
{
    case invalidUrl
    case networkError(NetworkError)
    case unknown(Error)
}
