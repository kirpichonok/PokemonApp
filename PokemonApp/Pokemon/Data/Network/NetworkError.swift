import Foundation

enum NetworkError: Error
{
    case requestFailed(statusCode: Int)
    case invalidUrl
    case connectionFailed
    case timedOut
    case parsingFailed(Error)
    case noResponse
}
