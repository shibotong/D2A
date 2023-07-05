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
    
    private func startLoadingImage() {
        Task {
            await fetchImage()
        }
    }
    
    private func computeURL() -> URL? {
        guard let id, let item = HeroDatabase.shared.fetchItem(id: id) else {
            return nil
        }
        let url = URL(string: "https://api.opendota.com\(item.img)")
        return url
    }
    
    private func fetchImage() async {
        if let id, let cacheImage = ImageCache.readImage(type: .item, id: id.description) {
            DispatchQueue.main.async {
                image = cacheImage
            }
            return
        }
        
        guard let newImage = await loadImage(), let id else {
            return
        }
        ImageCache.saveImage(newImage, type: .item, id: id.description)
        DispatchQueue.main.async {
            image = newImage
        }
    }
    
    private func loadImage() async -> UIImage? {
        guard let url = computeURL(),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
}

struct ItemViewContainer: View {
    @State var itemID: Int? = 1
    
    var body: some View {
        ItemView(id: $itemID)
            .task {
                await changeItem()
            }
    }
    
    private func changeItem() async {
        for _ in 0...4 {
            if #available(iOS 16.0, *) {
                try? await Task.sleep(for: .seconds(3))
            }
            itemID! += 1
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ItemViewContainer()
        }
        
    }
}
