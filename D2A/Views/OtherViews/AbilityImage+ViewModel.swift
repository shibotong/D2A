//
//  AbilityImageViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 26/2/2023.
//

import Foundation
import UIKit
import Networking
import Logging

extension AbilityImage {
    class ViewModel: ObservableObject {
        @Published var image: UIImage?
        
        let name: String
        
        private let imageProvider: ImageProviding
        private let client: APIClientProtocol
        private let logger: Logger?
        
        init(name: String,
             imageProvider: ImageProviding = ImageProvider.shared,
             client: APIClientProtocol = APIClient.shared,
             logger: Logger? = D2ALogger.ui) {
            self.name = name
            self.imageProvider = imageProvider
            self.client = client
            self.logger = logger
            image = imageProvider.read(type: .ability, id: name)
        }
        
        @MainActor
        func fetchImage() async {
            logger?.info("Start fetching image \(name)")
            guard let newImage = await loadImage() else {
                return
            }
            imageProvider.save(newImage, type: .ability, id: name)
            self.image = newImage
        }
        
        private func loadImage() async -> UIImage? {
            let urlString = "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/abilities/\(name).png"
            do {
                guard let url = URL(string: urlString) else {
                    logger?.error("The url is not in correct format \(urlString)")
                    return nil
                }
                let data = try await client.url(url)
                guard let image = UIImage(data: data) else {
                    logger?.error("Data fetched from url is not an image.")
                    return nil
                }
                return image
            } catch {
                logger?.error("Failed to load image data: \(error)")
                return nil
            }
        }
    }
}
