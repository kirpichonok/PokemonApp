extension Error {
    var isConnectionError: Bool {
        if let error = self as? NetworkError,
           case .connectionFailed = error {
            return true
        } else {
            return false
        }
    }
}
