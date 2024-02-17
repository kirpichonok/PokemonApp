import Foundation

extension PokemonPageDataModel
{
    struct PokemonPreviewDataModel
    {
        let name: String
        let urlString: String
    }
}

extension PokemonPageDataModel.PokemonPreviewDataModel: Decodable
{
    enum CodingKeys: String, CodingKey
    {
        case name
        case urlString = "url"
    }
}
