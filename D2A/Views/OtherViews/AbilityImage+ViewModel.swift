//
//  AbilityImageViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 26/2/2023.
//

import Foundation
import UIKit
import Networking

extension AbilityImage {
    class ViewModel: ObservableObject {
        @Published var image: UIImage?
        
        let name: String
        
        private let imageProvider: ImageProviding
        private let client: APIClientProtocol
        
        init(name: String,
             imageProvider: ImageProviding = ImageProvider.shared,
             client: APIClientProtocol = APIClient.shared) {
            self.name = name
            self.imageProvider = imageProvider
            self.client = client
            image = imageProvider.read(type: .ability, id: name)
        }
        
        @MainActor
        func fetchImage() async throws {
            let newImage = try await loadImage()
            imageProvider.save(newImage, type: .ability, id: name)
            self.image = newImage
        }
        
        private func loadImage() async throws -> UIImage {
            let urlString = "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/abilities/\(name).png"
            let (data, _) = try await client.get(urlString)
            guard let image = UIImage(data: data) else {
                throw D2AError(category: .image, message: "Data fetched from url is not an image. (\(urlString))")
            }
            return image
        }
    }
}
