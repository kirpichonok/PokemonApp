import SwiftUI

struct SwitchPageView: View
{
    var pageViewModel: PageViewModel
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

#Preview {
    SwitchPageView(pageViewModel: PageViewModel.empty)
}
