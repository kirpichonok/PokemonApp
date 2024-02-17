import Foundation

struct PokemonPageDataModel
{
    let list: [PokemonPreviewDataModel]
    let count: Int
    let nextPagePath: String?
    let previousPagePath: String?
}

extension PokemonPageDataModel: Decodable
{
    enum CodingKeys: String, CodingKey
    {
        case list = "results"
        case count
        case nextPagePath = "next"
        case previousPagePath = "previous"
    }
}
