import Foundation

enum ApiEndpoint
{
    case initialPage
    case resource(url: URL)
}

extension ApiEndpoint
{
    var responseDecoder: JSONDecoder
    {
        switch self
        {
        case .initialPage, .resource:
            return JSONDecoder()
        }
    }
}
