import Foundation

struct PokemonPage {
    let list: [PokemonPreview]
    let totalCount: Int

    static var pageCapacity = 20
}
