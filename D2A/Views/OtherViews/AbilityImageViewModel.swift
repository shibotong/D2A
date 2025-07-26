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
    
    private let imageProvider: GameImageProviding

    init(name: String?, urlString: String?,
         imageProvider: GameImageProviding = GameImageProvider.shared) {
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
