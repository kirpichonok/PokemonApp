import Foundation

enum ApiEndpoint
{
    case page(number: Int)
    case pokemonDetails(url: URL)
}

extension ApiEndpoint
{
    var responseDecoder: JSONDecoder
    {
        switch self
        {
        case .page, .pokemonDetails:
            return JSONDecoder()
        }
    }
}
