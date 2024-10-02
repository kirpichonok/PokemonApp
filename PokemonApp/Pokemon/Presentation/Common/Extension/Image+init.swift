import SwiftUI

extension Image {
    init(data: Data?) {
        if let data, let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            self.init(systemName: .SystemImageName.photo)
        }
    }
}
