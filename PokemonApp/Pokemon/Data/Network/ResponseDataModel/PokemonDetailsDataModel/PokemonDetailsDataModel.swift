import Foundation

struct PokemonDetailsDataModel {
//    let id: Int
    let name: String
    let type: String
    let weight: Int
    let height: Int
    let imagePath: String
}

extension PokemonDetailsDataModel
{
    func toDomain() -> Pokemon
    {
        .init(name: name,
              type: type, weight: weight,
              height: height,
              imagePath: imagePath)
    }
}
