//
//  HeroesGridView.swift
//  D2A
//
//  Created by Shibo Tong on 25/4/2026.
//

import SwiftUI

struct HeroesGridView: View {
    
    let heroes: [Hero]
    
    var body: some View {
        if heroes.isEmpty {
            Text("No Results")
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 130, maximum: 200), spacing: 10, alignment: .leading), count: 1)) {
                    ForEach(heroes, id: \.id) { hero in
                        NavigationLink(destination: HeroDetailView(hero: hero)) {
                            buildHero(hero: hero)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func buildHero(hero: Hero) -> some View {
        ZStack {
            HeroImageView(heroID: hero.id, type: .full)
                .overlay(LinearGradient(colors: [.black.opacity(0), .black.opacity(0), .black], startPoint: .top, endPoint: .bottom))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .accessibilityIdentifier(hero.localizedName)
            HStack {
                VStack {
                    Spacer()
                    HStack(spacing: 3) {
                        AttributeImage(attribute: HeroAttribute(rawValue: hero.primaryAttribute)).frame(width: 15, height: 15)
                        Text(hero.localizedName)
                            .font(.caption2)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .padding(5)
        }
    }
}

#Preview {
    NavigationView {
        HeroesGridView(heroes: PreviewData.heroes)
    }
}
