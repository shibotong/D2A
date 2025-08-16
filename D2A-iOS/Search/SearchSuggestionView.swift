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
    
    var body: some View {
        Group {
            ForEach(users) { profile in
                Label("\(profile.personaname ?? "")", systemImage: "person.crop.circle")
                    .searchCompletion(profile.personaname ?? "")
            }
            ForEach(heroes) { hero in
                HStack {
                    HeroImageViewV2(hero: hero, type: .full)
                        .frame(height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    VStack(alignment: .leading) {
                        Text(hero.heroNameLocalized)
                        Text("Hero")
                            .font(.subheadline)
                            .foregroundStyle(Color.secondaryLabel)
                    }
                }
            }
        }
        .listStyle(.plain)
        .foregroundColor(.label)
    }
}

#Preview {
    SearchSuggestionView(users: [], heroes: [Hero.antimage])
        .environmentObject(ImageController.preview)
}
