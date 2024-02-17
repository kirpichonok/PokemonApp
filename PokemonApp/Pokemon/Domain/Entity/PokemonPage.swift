import Foundation

struct PokemonPage
{
    let list: [PokemonPreview]
    let totalCount: Int
    let nextPagePath: String?
    let previousPagePath: String?
}
