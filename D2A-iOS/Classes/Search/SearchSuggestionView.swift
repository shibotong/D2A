//
//  SearchSuggestionView.swift
//  D2A
//
//  Created by Shibo Tong on 16/8/2025.
//

import SwiftUI

struct SearchSuggestionView: View {
    
    @Environment(\.managedObjectContext) var context
    
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
                .onTapGesture {
                    addSeaarch(item: profile)
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
                .onTapGesture {
                    addSeaarch(item: hero)
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
    
    private func addSeaarch(item: Any) {
        let searchHistory = SearchHistory(context: context)
        searchHistory.searchTime = Date()
        if let user = item as? UserProfile {
            searchHistory.player = user
        } else if let hero = item as? Hero {
            searchHistory.hero = hero
        } else if let match = item as? Match {
            searchHistory.match = match
        } else {
            logError("search item is not supported", category: .coredata)
            return
        }
        do {
            try context.save()
        } catch {
            logError("Not able to save search history", category: .coredata)
        }
    }
}

#Preview {
    NavigationStack {
        SearchSuggestionView(users: [UserProfile.user], heroes: [Hero.antimage])
    }
    .environmentObject(EnvironmentController.preview)
    .environment(\.managedObjectContext, PersistanceProvider.preview.mainContext)
}
