import Foundation

struct PokemonDescriptionViewModel {
    let name: String
    let type: String
    let weight: String
    let height: String

    init() {
        name = ""
        type = ""
        weight = ""
        height = ""
    }
}

extension PokemonDescriptionViewModel {
    init(pokemon: Pokemon) {
        name = pokemon.name.capitalized
        type = pokemon.type
        weight = pokemon.weight.formatted() + " g"
        height = pokemon.height.formatted() + " cm"
    }
}
