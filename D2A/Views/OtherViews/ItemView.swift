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
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image).resizable()
            } else {
                Image("empty_item").resizable()
            }
        }
        .task {
            await fetchImage()
        }
    }
    
    private func computeURL() -> URL? {
        guard let item = HeroDatabase.shared.fetchItem(id: id) else {
            return nil
        }
        let url = URL(string: "https://api.opendota.com\(item.img)")
        return url
    }
    
    private func fetchImage() async {
        if let cacheImage = ImageCache.readImage(type: .item, id: id.description) {
            Dispatch.DispatchQueue.main.async {
                image = cacheImage
            }
            return
        }
        
        guard let newImage = await loadImage() else {
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
