import Foundation
import Moya

extension ApiEndpoint: TargetType {
    var baseURL: URL {
        switch self {
        case .page:
            guard let url = URL(string: AppConfiguration.baseURL) else { fatalError("Invalid base URL.") }
            return url
        case let .pokemonDetails(url: url):
            return url
        case let .image(url: url):
            return url
        }
    }

    var path: String {
        switch self {
        case .page, .pokemonDetails, .image:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .page, .pokemonDetails, .image:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case let .page(number: pageNumber):
            let offsetIndex = pageNumber - 1
            return .requestParameters(
                parameters: ["offset": offsetIndex * PokemonPage.pageCapacity,
                             "limit": PokemonPage.pageCapacity],
                encoding: URLEncoding.default
            )
        case .pokemonDetails, .image:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        nil
    }
}
