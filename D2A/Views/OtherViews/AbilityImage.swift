//
//  AbilityImage.swift
//  D2A
//
//  Created by Shibo Tong on 26/2/2023.
//

import SwiftUI
import UIKit

struct AbilityImage: View {
    @EnvironmentObject var imageController: ImageController
    
    @State private var image: UIImage?
    
    private let name: String?
    private let urlString: String?
    
    init(name: String?, urlString: String?) {
        self.name = name
        self.urlString = urlString
    }

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image("ability_slot")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.label)
            }
        }
        .task {
            await loadImage()
        }
    }
    
    @MainActor
    private func loadImage() async {
        guard let name, let urlString else {
            return
        }
        await imageController.refreshImage(type: .ability, id: name, url: urlString) { image in
            self.image = image
        }
    }
}

#Preview {
    AbilityImage(name: "Acid Spray", urlString: "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/abilities/alchemist_acid_spray.png")
        .environmentObject(ImageController.preview)
}
