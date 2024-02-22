import SwiftUI

struct ErrorView: View
{
    // MARK: - Properties

    let error: Error
    var reloadAction: (() -> Void)?
    var body: some View
    {
        VStack(spacing: 20)
        {
            Image(systemName: error.isConnectionError ?
                .SystemImageName.wifiExclamationMark :
                .SystemImageName.xMarkCircle
            )
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundStyle(error.isConnectionError ?
                Color.accentColor :
                .red
            )

            Text(errorTitle)
                .foregroundStyle(.red)
                .font(.system(.title2, weight: .semibold))

            Text(error.localizedDescription)
                .multilineTextAlignment(.center)

            Button
            {
                reloadAction?()
            }
            label:
            {
                Label
                {
                    Text(reloadButtonTitle)
                }
                icon:
                {
                    Image(systemName: .SystemImageName.arrowClockwiseCircle)
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding([.top], 30)
        }
        .padding()
        .background(.bar)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }

    // MARK: - Private properties

    private let errorTitle = "Error!"
    private let reloadButtonTitle = "Reload"
}

#Preview
{
    VStack
    {
        ErrorView(error: NetworkError.connectionFailed)
        ErrorView(error: NetworkError.invalidUrl)
    }
}
