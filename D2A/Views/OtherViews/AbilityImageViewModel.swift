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
    
    let name: String
    
    private var url: URL? {
        return URL(string: "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/abilities/\(name).png") ?? nil
    }

    let urlString: String?
    private let imageProvider: ImageProviding
    
    convenience init(name: String, imageProvider: ImageProviding = ImageProvider.shared) {
        self.init(name: name, urlString: "", imageProvider: imageProvider)
    }
    
    init(name: String?, urlString: String?,
         imageProvider: ImageProviding = ImageProvider.shared) {
        self.name = name ?? ""
        self.urlString = urlString
        self.imageProvider = imageProvider
        if let name {
            self.image = imageProvider.read(type: .ability, id: name)
            Task {
                await fetchImage()
            }
        }
    }
    
    @MainActor
    private func fetchImage() async {
        if image != nil {
            return
        }
        guard let newImage = await loadImage() else {
            return
        }
        imageProvider.save(newImage, type: .ability, id: name)
        self.image = newImage
    }
    
    private func loadImage() async -> UIImage? {
        guard let url,
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
}
