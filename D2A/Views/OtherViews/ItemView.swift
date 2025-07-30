//
//  ItemView.swift
//  D2A
//
//  Created by Shibo Tong on 29/1/2023.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var heroData: ConstantsController
    @EnvironmentObject var imageController: ImageController
    @State var image: UIImage?

    @Binding var id: Int?

    func updateUI() {
        Task {
            await fetchImage()
        }
    }

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image("empty_item")
                    .resizable()
            }
        }
        .task(id: id) {
            await fetchImage()
        }
    }

    private func computeURL() -> String? {
        guard let id, let item = ConstantsController.shared.fetchItem(id: id) else {
            return nil
        }
        return "\(IMAGE_PREFIX)\(item.img)"
    }

    @MainActor
    private func fetchImage() async {
        guard let id else {
            self.image = nil
            return
        }
        try? await imageController.refreshImage(type: .item, id: id.description, url: computeURL() ?? "") { image in
            self.image = image
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    @State static var id: Int? = 1
    static var previews: some View {
        VStack {
            ItemView(id: $id)
        }

    }
}
