import Foundation

struct PokemonPageDataModel {
    let list: [PokemonPreviewDataModel]
    let count: Int
}

extension PokemonPageDataModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case list = "results"
        case count
    }
}

extension PokemonPageDataModel {
    func toDomain() -> PokemonPage {
        .init(
            list: list.map { $0.toDomain() },
            totalCount: count
        )
    }
}
