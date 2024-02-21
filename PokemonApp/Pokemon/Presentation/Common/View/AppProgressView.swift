import SwiftUI

struct AppProgressView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2)
            .tint(.accentColor)
    }
}

#Preview {
    AppProgressView()
}
