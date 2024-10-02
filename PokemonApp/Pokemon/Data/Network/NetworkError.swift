import Foundation

enum NetworkError {
    /// Request execution error.
    case requestFailed(statusCode: Int)
    /// Failed to create a valid URL.
    case invalidUrl
    /// Indicates absence or problems with network connection.
    case connectionFailed
    /// Indicates that request exceed allowed time.
    case timedOut
    /// Indicates a response failed to map to a Decodable object.
    case parsingFailed(Error)
    /// Underlying error.
    case unknown(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .requestFailed(statusCode: code):
            return "Execution error with code: \(code). Try again later or contact developer."
        case .invalidUrl:
            return "Error executing link request." + NetworkError.contactDeveloperMessage
        case .connectionFailed:
            return "No internet connection. Check and restart the app."
        case .timedOut:
            return "Request exceeded time limit. Retry later."
        case let .parsingFailed(error):
            return "Data decoding is failed with error: \(error.localizedDescription)." + NetworkError.contactDeveloperMessage
        case let .unknown(error):
            return "Underlying error: \(error.localizedDescription)." + NetworkError.contactDeveloperMessage
        }
    }

    private static let contactDeveloperMessage = "\nContact developer."
}
