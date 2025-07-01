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

    var name: String?
    let urlString: String?
    
    private let imageProvider: ImageProviding

    init(name: String?, urlString: String?,
         imageProvider: ImageProviding = ImageProvider.shared) {
        self.name = name
        self.urlString = urlString
        self.imageProvider = imageProvider
        if let name {
            self.image = imageProvider.localImage(type: .ability, id: name, fileExtension: .jpg)
            Task {
                await fetchImage()
            }
        }
    }

    init(imageProvider: ImageProviding = ImageProvider.shared) {
        name = "Acid Spray"
        urlString =
            "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/abilities/alchemist_acid_spray.png"
        image = UIImage(named: "ability_slot")
        self.imageProvider = imageProvider
    }

    private func fetchImage() async {
        if image != nil {
            return
        }
        guard let name,
            let newImage = await loadImage()
        else {
            return
        }
        imageProvider.saveImage(image: newImage, type: .ability, id: name, fileExtension: .jpg)
        await setImage(newImage)
    }

    private func loadImage() async -> UIImage? {
        guard let urlString,
            let url = URL(string: urlString),
            let (newImageData, _) = try? await URLSession.shared.data(from: url),
            let newImage = UIImage(data: newImageData)
        else {
            return nil
        }
        return newImage
    }

    @MainActor
    private func setImage(_ image: UIImage) {
        self.image = image
    }

}
