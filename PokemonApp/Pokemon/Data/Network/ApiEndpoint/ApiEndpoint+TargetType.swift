import Foundation
import Moya

extension ApiEndpoint: TargetType
{
    var baseURL: URL
    {
        switch self
        {
        case .initialPage:
            guard let url = URL(string: AppConfiguration.baseURL) else { fatalError("Invalid base URL.") }
            return url
        case let .resource(url: url):
            return url
        }
    }

    var path: String
    {
        switch self
        {
        case .initialPage, .resource:
            return ""
        }
    }

    var method: Moya.Method
    {
        switch self
        {
        case .initialPage, .resource:
            return .get
        }
    }

    var task: Moya.Task
    {
        switch self
        {
        case .initialPage, .resource:
            return .requestPlain
        }
    }

    var headers: [String: String]?
    {
        nil
    }
}
