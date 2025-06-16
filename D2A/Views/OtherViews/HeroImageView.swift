//
//  HeroIconImageView.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import SwiftUI

enum HeroImageType: String {
    case icon, portrait, full, vert
}

struct HeroImageView: View {
    @EnvironmentObject var heroData: ConstantsController
    @EnvironmentObject var imageController: ImageController
    
    let heroID: Int
    let type: HeroImageType
    
    @State private var image: UIImage?

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
        let heroImageID = "\(heroID.description)_\(type.rawValue)"
        await imageController.refreshImage(type: .hero, id: heroImageID, fileExtension: .png, url: computeURLString()) { image in
            self.image = image
        }
    }
    
    private func computeURLString() -> String {
        guard let hero = try? heroData.fetchHeroWithID(id: heroID) else {
            return ""
        }
        let name = hero.name.replacingOccurrences(of: "npc_dota_hero_", with: "")
        switch type {
        case .icon:
            return "https://api.opendota.com\(hero.icon)"
        case .portrait:
            return "\(IMAGE_PREFIX)/apps/dota2/videos/dota_react/heroes/renders/\(name).png"
        case .full:
            return "https://cdn.akamai.steamstatic.com/apps/dota2/images/dota_react/heroes/\(name).png"
        case .vert:
            return ""
        }
    }
}

#Preview {
    HeroImageView(heroID: 1, type: .icon)
        .environmentObject(ConstantsController.preview)
        .environmentObject(ImageController.preview)
}
