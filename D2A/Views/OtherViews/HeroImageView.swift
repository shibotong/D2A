//
//  HeroIconImageView.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import SwiftUI

enum HeroImageType: String {
    case icon, full, vert
}

struct HeroImageView: View {
    @EnvironmentObject var imageController: ImageController
    @Environment(\.managedObjectContext) var viewContext
    
    private let heroID: Int
    private let type: HeroImageType
    private var hero: Hero?
    
    @State private var image: UIImage?
    
    init(hero: Hero, type: HeroImageType) {
        self.hero = hero
        self.type = type
        self.heroID = Int(hero.id)
    }
    
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
        await imageController.refreshImage(type: .hero(type: type), id: heroImageID, fileExtension: .png, url: computeURLString()) { image in
            self.image = image
        }
    }
    
    private func computeURLString() -> String {
        guard let hero = self.hero ?? Hero.fetch(id: heroID, context: viewContext),
              let heroName = hero.name,
              let heroIcon = hero.icon else {
            return ""
        }
        let name = heroName.replacingOccurrences(of: "npc_dota_hero_", with: "")
        switch type {
        case .icon:
            return "https://api.opendota.com\(heroIcon)"
        case .full:
            return "https://cdn.akamai.steamstatic.com/apps/dota2/images/dota_react/heroes/\(name).png"
        case .vert:
            return "https://cdn.stratz.com/images/dota2/heroes/\(name)_vert.png"
        }
    }
}

#if DEBUG
#Preview {
    HeroImageView(heroID: 1, type: .icon)
        .environmentObject(ImageController.preview)
        .environment(\.managedObjectContext, PersistanceProvider.preview.container.viewContext)
}
#endif
