import Foundation

extension PokemonListViewModel
{
    enum Page
    {
        case initial
        case next
        case previous
    }
}

extension PokemonListViewModel.Page
{
    func toDomain() -> Page
    {
        switch self
        {
        case .initial:
            return .initial
        case .next:
            return .next
        case .previous:
            return .previous
        }
    }
}
