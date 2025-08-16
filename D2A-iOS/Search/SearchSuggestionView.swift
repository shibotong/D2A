//
//  SearchSuggestionView.swift
//  D2A
//
//  Created by Shibo Tong on 16/8/2025.
//

import SwiftUI

struct SearchSuggestionView: View {
    
    let users: [UserProfile]
    let heroes: [Hero]
    
    private let imageSize: CGFloat = 40
    
    var body: some View {
        Group {
            ForEach(users) { profile in
                NavigationLink(destination: Text("PlayerProfileView")) {
                    HStack {
                        ProfileAvatar(profile: profile, cornerRadius: 5)
                            .frame(width: imageSize)
                        buildTitle(title: profile.personaname ?? "Unknown", subTitle: profile.id ?? "")
                    }
                }
            }
            ForEach(heroes) { hero in
                NavigationLink(destination: HeroDetailViewV2(hero: hero)) {
                    HStack {
                        HeroImageViewV2(hero: hero, type: .icon)
                            .frame(width: imageSize)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        buildTitle(title: hero.heroNameLocalized, subTitle: "Hero")
                    }
                }
            }
        }
        .listStyle(.plain)
        .foregroundColor(.label)
    }
    
    @ViewBuilder
    private func buildTitle(title: String, subTitle: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
            Text(subTitle)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryLabel)
        }
    }
}

#Preview {
    NavigationStack {
        SearchSuggestionView(users: [UserProfile.user], heroes: [Hero.antimage])
    }
    .environmentObject(ImageController.preview)
    .environment(\.managedObjectContext, PersistanceProvider.preview.mainContext)
}
