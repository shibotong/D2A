//
//  AbilityImageViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 26/2/2023.
//

import Foundation
import UIKit

class AbilityImageViewModel: ObservableObject {
    @Published var image: UIImage?
    
    var name: String
    var urlString: String
    
    init(name: String, urlString: String) {
        self.name = name
        self.urlString = urlString
        self.image = ImageCache.readImage(type: .ability, id: name)
        Task {
            await fetchImage()
        }
    }
    
    init() {
        name = "Acid Spray"
        urlString = "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/abilities/alchemist_acid_spray.png"
        image = UIImage(named: "ability_slot")
    }
    
    private func fetchImage() async {
        if image != nil {
            return
        }
        guard let newImage = await loadImage() else {
            return
        }
        ImageCache.saveImage(newImage, type: .ability, id: name)
        await setImage(newImage)
    }
    
    private func loadImage() async -> UIImage? {
        guard let url = URL(string: urlString),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
    
    @MainActor
    private func setImage(_ image: UIImage) {
        self.image = image
    }
    
}
