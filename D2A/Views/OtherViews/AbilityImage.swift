//
//  AbilityImage.swift
//  D2A
//
//  Created by Shibo Tong on 26/2/2023.
//

import SwiftUI
import UIKit

struct AbilityImage: View {
    var name: String
    var urlString: String
    let sideLength: CGFloat
    let cornerRadius: CGFloat
    
    @State var image: UIImage?
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image("ability_slot")
                    .renderingMode(.template)
                    .resizable()
            }
        }
        .frame(width: sideLength, height: sideLength)
        .task {
            await fetchImage()
        }
    }
    
    private func fetchImage() async {
        if let cacheImage = ImageCache.readImage(type: .ability, id: name) {
            Dispatch.DispatchQueue.main.async {
                image = cacheImage
            }
            return
        }
        guard let newImage = await loadImage() else {
            return
        }
        ImageCache.saveImage(newImage, type: .ability, id: name)
        DispatchQueue.main.async {
            image = newImage
        }
    }
    
    private func loadImage() async -> UIImage? {
        guard let url = URL(string: urlString),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
}
