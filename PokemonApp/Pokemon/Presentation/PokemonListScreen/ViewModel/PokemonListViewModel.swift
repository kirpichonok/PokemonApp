import Foundation

final class PokemonListViewModel: ObservableObject {
    @Published private(set) var listOfPokemons = [
        "name1",
        "name2",
        "name3",
        "name4",
        "name5",
        "name6",
        ]
}
