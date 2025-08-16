//
//  HeroImageViewV2.swift
//  D2A
//
//  Created by Shibo Tong on 27/7/2025.
//

import SwiftUI

struct HeroImageViewV2: View {
    @EnvironmentObject var imageController: ImageController
    
    @State private var image: UIImage?
    
    private let name: String
    private let type: HeroImageType
    
    init(hero: Hero, type: HeroImageType) {
        self.init(name: hero.heroNameLowerCase, type: type)
    }
    
    init(name: String, type: HeroImageType) {
        self.name = name
        self.type = type
    }
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                loadingView
            }
        }
        .task {
            await loadImage()
        }
    }
    
    var loadingView: some View {
        ZStack {
            Group {
                if type == .full {
                    Image(.heroFullSlot)
                        .renderingMode(.template)
                        .resizable()
                }
                if type == .icon {
                    Image(.heroIconSlot)
                        .renderingMode(.template)
                        .resizable()
                }
                if type == .vert {
                    Image(.heroVertSlot)
                        .renderingMode(.template)
                        .resizable()
                }
            }
            .aspectRatio(contentMode: .fit)
            ProgressView()
        }
    }
    
    @MainActor
    private func loadImage() async {
        try? await imageController.refreshImage(type: .hero(type: type), id: name, fileExtension: .png, url: computeURLString()) { image in
            self.image = image
        }
    }

    private func computeURLString() -> String {
        switch type {
        case .icon:
            return "https://cdn.steamstatic.com/apps/dota2/images/dota_react/heroes/icons/\(name).png"
        case .full:
            return "https://cdn.akamai.steamstatic.com/apps/dota2/images/dota_react/heroes/\(name).png"
        case .vert:
            return "https://cdn.stratz.com/images/dota2/heroes/\(name)_vert.png"
        }
    }
}

#if DEBUG
#Preview {
    HeroImageViewV2(name: "antimage", type: .full)
        .environmentObject(ImageController.preview)
}
#endif
