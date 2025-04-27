//
//  ItemView.swift
//  D2A
//
//  Created by Shibo Tong on 29/1/2023.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var heroData: HeroDatabase
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
    
    private func computeURL() -> URL? {
        guard let id, let item = HeroDatabase.shared.fetchItem(id: id) else {
            return nil
        }
        let url = URL(string: "\(IMAGE_PREFIX)\(item.img)")
        return url
    }
    
    private func fetchImage() async {
        guard let id else {
            setImage(nil)
            return
        }
        
        if let cacheImage = ImageCache.shared.readImage(type: .item, id: id.description) {
            setImage(cacheImage)
            return
        }
        
        guard let newImage = await loadImage() else {
            setImage(nil)
            return
        }
        ImageCache.shared.saveImage(newImage, type: .item, id: id.description)
        setImage(newImage)
    }
    
    private func loadImage() async -> UIImage? {
        guard let url = computeURL(),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
    
    @MainActor
    private func setImage(_ image: UIImage?) {
        self.image = image
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
