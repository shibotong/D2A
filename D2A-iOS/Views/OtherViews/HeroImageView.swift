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
    
    @State private var name: String?
    private let type: HeroImageType
    private let heroID: Int?
    
    init(hero: Hero, type: HeroImageType) {
        self.name = hero.heroNameLowerCase
        self.type = type
        heroID = nil
    }
    
    init(heroID: Int, type: HeroImageType) {
        self.heroID = heroID
        self.type = type
    }

    var body: some View {
        Group {
            if let name {
                HeroImageViewV2(name: name, type: type)
            } else {
                loadingView
            }
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
        .task {
            await loadImage()
        }
    }
    
    @MainActor
    private func loadImage() async {
        guard name == nil else {
            return
        }
        let hero = Hero.fetch(id: heroID ?? 0, context: viewContext)
        self.name = hero?.heroNameLowerCase
    }
}

#if DEBUG
#Preview {
    HeroImageView(heroID: 1, type: .icon)
        .environmentObject(ImageController.preview)
        .environment(\.managedObjectContext, PersistanceProvider.preview.container.viewContext)
}
#endif
