import SwiftUI

struct SwitchPageView: View
{
    var pageViewModel: PokemonListViewModel
    var backAction: (() -> Void)?
    var nextAction: (() -> Void)?
    var body: some View
    {
        HStack(spacing: 40)
        {
            Button
            {
                backAction?()
            }
            label:
            {
                Image(systemName: .SystemImageName.chevronBackwardSquare)
                    .font(.title2)
            }
            .buttonStyle(.bordered)
            .allowsHitTesting(!pageViewModel.previousPageDisabled)
            .foregroundStyle(pageViewModel.previousPageDisabled ? .gray : .accentColor)

            Text(pageViewModel.currentPageNumber.formatted() +
                " / " + pageViewModel.numberOfPages.formatted())
                .font(.title2)

            Button
            {
                nextAction?()
            }
            label:
            {
                Image(systemName: .SystemImageName.chevronForwardSquare)
            }
            .font(.title2)
            .buttonStyle(.bordered)
            .allowsHitTesting(!pageViewModel.nextPageDisabled)
            .foregroundStyle(pageViewModel.nextPageDisabled ? .gray : .accentColor)
        }
    }
}

#Preview
{
    let viewModel = AppDIContainer().makePokemonListViewModel(with: nil)
    return PokemonListView(viewModel: viewModel)
}
