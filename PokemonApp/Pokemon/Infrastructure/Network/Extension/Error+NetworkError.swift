import Foundation

extension Error {
    func convertToNetworkError() -> NetworkError {
        let code = URLError.Code(rawValue: (self as NSError).code)
        switch code {
        case .notConnectedToInternet, .networkConnectionLost, .cannotConnectToHost:
            return .connectionFailed
        case .timedOut:
            return .timedOut
        default:
            return .unknown(self)
        }
    }
}
