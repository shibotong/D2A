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
    private let isInnate: Bool
    
    init(name: String?, isInnate: Bool = false) {
        self.name = name
        self.isInnate = isInnate
    }

    private var fullURL: String {
        guard let name else {
            return ""
        }
        return "https://cdn.steamstatic.com/apps/dota2/images/dota_react/abilities/\(name).png"
    }
    var body: some View {
        ZStack {
            if isInnate {
                Image(.innateIcon)
                    .resizable()
            } else if let image {
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
        guard let name else {
            return
        }
        try? await imageController.refreshImage(type: .ability, id: name, url: fullURL) { image in
            self.image = image
        }
    }
}

#Preview {
    AbilityImage(name: "Acid Spray")
        .environmentObject(ImageController.preview)
}
