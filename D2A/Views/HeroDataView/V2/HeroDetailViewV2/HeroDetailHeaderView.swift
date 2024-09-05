//
//  HeroDetailHeaderView.swift
//  D2A
//
//  Created by Shibo Tong on 30/8/2024.
//

import SwiftUI

struct HeroDetailHeaderView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontal
    
    let heroID: Int
    let name: String
    let attribute: HeroAttribute
    let complexity: Int
    
    var body: some View {
        if horizontal == .compact {
            iPhone
        } else {
            iPad
        }
    }
    
    private var iPad: some View {
        HStack {
            heroImage
            attributeImage
            Text(LocalizedStringKey(name))
                .font(.body)
                .bold()
            Text("\(heroID)")
                .font(.caption2)
                .foregroundColor(.label.opacity(0.5))
            HeroComplexityView(heroComplexity: complexity)
            Spacer()
//            buildAbilities(navigation: false)
        }
        .frame(height: 50)
        .padding()
        .background(Color.secondarySystemBackground)
    }
    
    private var iPhone: some View {
        heroImage
            .overlay(
                LinearGradient(colors: [Color(.black).opacity(0),
                                        Color(.black).opacity(1)],
                               startPoint: .top,
                               endPoint: .bottom))
            .overlay(HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Spacer()
                    HStack {
                        attributeImage
                        Text(LocalizedStringKey(name))
                            .font(.system(size: 30))
                            .bold()
                            .foregroundColor(.white)
                        Text("\(heroID)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                        HeroComplexityView(heroComplexity: complexity)
                    }
                }
                Spacer()
            }.padding(.leading))
    }
    
    private var heroImage: some View {
        HeroImageView(heroID: heroID, type: .full)
    }
    
    private var attributeImage: some View {
        AttributeImage(attribute: attribute)
            .frame(width: 25, height: 25)
    }
    
//    if horizontal == .compact {

//    } else {

//    }
}

#Preview {
    HeroDetailHeaderView(heroID: 1, name: "Hero Name", attribute: .agi, complexity: 1)
}
