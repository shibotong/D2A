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
            do {
                let newImage = try await loadImage()
                imageProvider.save(newImage, type: .ability, id: name)
                self.image = newImage
            } catch {
                logger?.error("\(error.localizedDescription)")
            }
        }
        
        private func loadImage() async throws -> UIImage {
            let urlString = "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/abilities/\(name).png"
            let url = URL(string: urlString)!
            let data = try await client.url(url)
            guard let image = UIImage(data: data) else {
                throw D2AError(category: .image, message: "Data fetched from url is not an image. (\(urlString))")
            }
            return image
        }
    }
}
