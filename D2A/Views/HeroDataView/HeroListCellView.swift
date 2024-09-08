//
//  HeroListCellView.swift
//  D2A
//
//  Created by Shibo Tong on 8/9/2024.
//

import SwiftUI

struct HeroListCellView: View {
    
    @Environment(\.horizontalSizeClass) var horizontal
    
    var heroName: String
    var heroID: Int
    var attribute: HeroAttribute
    
    var isGrid: Bool
    var isHighlighted: Bool
    
    init(heroName: String, heroID: Int, attribute: HeroAttribute, isGrid: Bool, isHighlighted: Bool) {
        self.heroName = heroName
        self.heroID = heroID
        self.attribute = attribute
        self.isGrid = isGrid
        self.isHighlighted = isHighlighted
    }
    
    var body: some View {
        Group {
            if horizontal == .regular {
                HeroImageView(heroID: heroID, type: .vert)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .opacity(isHighlighted ? 1 : 0.2)
                    .accessibilityIdentifier(heroName)
            }
            
            if horizontal == .compact && isGrid {
                ZStack {
                    HeroImageView(heroID: heroID, type: .full)
                        .overlay(LinearGradient(colors: [.black.opacity(0), .black.opacity(0), .black], startPoint: .top, endPoint: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .accessibilityIdentifier(heroName)
                    HStack {
                        VStack {
                            Spacer()
                            HStack(spacing: 3) {
                                AttributeImage(attribute: attribute)
                                    .frame(width: 15, height: 15)
                                Text(heroName)
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
            
            if horizontal == .compact && !isGrid {
                HStack {
                    HeroImageView(heroID: heroID, type: .full)
                        .frame(width: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Text(heroName)
                    Spacer()
                    AttributeImage(attribute: attribute)
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

#Preview {
    HeroListCellView(heroName: "Test Hero", heroID: 1, attribute: .agi, isGrid: true, isHighlighted: true)
}

#Preview {
    HeroListCellView(heroName: "Test Hero", heroID: 1, attribute: .agi, isGrid: false, isHighlighted: true)
}
