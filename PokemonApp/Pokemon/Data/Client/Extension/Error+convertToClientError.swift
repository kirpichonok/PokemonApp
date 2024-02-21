import Foundation

extension Error
{
    func convertToClientError() -> ClientError
    {
        guard let error = self as? NetworkError else { return .unknown(self) }
        return ClientError.networkError(error)
    }
}
