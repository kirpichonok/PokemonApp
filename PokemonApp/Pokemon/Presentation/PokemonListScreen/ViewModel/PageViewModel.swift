import Foundation

struct PageViewModel
{
    let listOfPokemons: [String]
    let currentPageNumber: Int
    let numberOfPages: Int
    var nextPageDisabled: Bool
    {
        currentPageNumber >= numberOfPages
    }

    var previousPageDisabled: Bool
    {
        currentPageNumber <= .zero
    }

    init(pokemonPage: PokemonPage,
         currentPageNumber: Int)
    {
        listOfPokemons = pokemonPage.list.map { $0.name.capitalized }
        self.currentPageNumber = abs(currentPageNumber)
        numberOfPages = PageViewModel.calculateNumberOfPages(totalCount: pokemonPage.totalCount)
    }
}

extension PageViewModel
{
    private static func calculateNumberOfPages(totalCount: Int) -> Int
    {
        let devisionResult = (Double(totalCount) / Double(PokemonPage.pageCapacity))
        return Int(ceil(devisionResult))
    }

    static let empty = PageViewModel(
        pokemonPage: PokemonPage(
            list: [],
            totalCount: 0
        ),
        currentPageNumber: 0
    )
}
