enum RequestState {
    case success
    case failed(withError: Error)
    case isLoading
}

extension RequestState: Equatable {
    static func == (lhs: RequestState, rhs: RequestState) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success): return true
        case (.isLoading, .isLoading): return true
        case let (.failed(withError: errorLhs), .failed(withError: errorRhs)):
            return errorLhs.localizedDescription == errorRhs.localizedDescription
        default: return false
        }
    }
}
