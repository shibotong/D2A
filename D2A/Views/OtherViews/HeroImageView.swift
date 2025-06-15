//
//  HeroIconImageView.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import SwiftUI

enum HeroImageType {
    case icon, portrait, full, vert
}

struct HeroImageView: View {
    @EnvironmentObject var heroData: ConstantsController
    @EnvironmentObject var fileController: FileController
    let heroID: Int
    let type: HeroImageType
    
    @State private var image: UIImage?
    
    init(heroID: Int, type: HeroImageType) {
        self.heroID = heroID
        self.type = type
    }

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
            }
        }
        .task {
            await loadImage()
        }
        
//        if type == .icon || type == .full || type == .vert {
//            if heroID == 0 && type == .icon {
//                Circle()
//                    .foregroundColor(Color.label.opacity(0.3))
//            } else {
//                Image(searchHeroImage())
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//            }
//        } else {
//            AsyncImage(url: computeURL()) { phase in
//                if let image = phase.image {
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)  // Displays the loaded image.
//                } else if phase.error != nil {
//                    ProgressView()  // Indicates an error.
//                } else {
//                    ProgressView()  // Acts as a placeholder.
//                }
//            }
//        }
    }
    
    @MainActor
    private func loadImage() async {
        let heroImageID = searchHeroImage()
        await fileController.refreshImage(type: .hero, id: heroImageID, fileExtension: .png, url: computeURLString()) { localImage in
            self.image = localImage
        }
    }

    private func searchHeroImage() -> String {
        switch type {
        case .icon:
            let filename = "\(heroID.description)_icon"
            return filename
        case .portrait:
            let filename = "\(heroID.description)_portrait"
            return filename
        case .full:
            let filename = "\(heroID.description)_full"
            return filename
        case .vert:
            let filename = "\(heroID.description)_vert"
            return filename
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

    private func computeURL() -> URL? {
        guard let hero = try? heroData.fetchHeroWithID(id: heroID) else {
            return nil
        }
        switch type {
        case .icon:
            let url = URL(string: "https://api.opendota.com\(hero.icon)")
            return url
        case .portrait:
            let name = hero.name.replacingOccurrences(of: "npc_dota_hero_", with: "")
            let url = URL(
                string: "\(IMAGE_PREFIX)/apps/dota2/videos/dota_react/heroes/renders/\(name).png")
            return url
        case .full:
            return nil
        case .vert:
            return nil
        }
    }
}

#Preview {
    HeroImageView(heroID: 1, type: .icon)
        .environmentObject(ConstantsController.preview)
        .environmentObject(FileController.preview)
}
