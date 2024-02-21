import Foundation

enum ApiEndpoint
{
    case page(number: Int)
    case resource(url: URL)
}

extension ApiEndpoint
{
    var responseDecoder: JSONDecoder
    {
        switch self
        {
        case .page, .resource:
            return JSONDecoder()
        }
    }
}
