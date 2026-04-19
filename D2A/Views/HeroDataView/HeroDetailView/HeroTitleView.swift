//
//  HeroTitleView.swift
//  D2A
//
//  Created by Shibo Tong on 19/4/2026.
//

import SwiftUI

struct HeroTitleView: View {
    
    let heroID: Int
    let primaryAttribute: String
    let displayName: String
    let heroComplexity: Int
    
    var body: some View {
        HeroImageView(heroID: heroID, type: .full)
            .overlay(
                LinearGradient(colors: [Color(.black).opacity(0),
                                        Color(.black).opacity(1)],
                               startPoint: .top,
                               endPoint: .bottom))
            .overlay(HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Spacer()
                    HStack {
                        Image("hero_\(primaryAttribute)")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text(displayName)
                            .font(.system(size: 30))
                            .bold()
                            .foregroundColor(.white)
                        Text("\(heroID)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                        HStack {
                            ForEach(1..<4) { complexity in
                                if complexity <= heroComplexity {
                                    RoundedRectangle(cornerRadius: 3)
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.white)
                                        .rotationEffect(.degrees(45))
                                } else {
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.white)
                                        .rotationEffect(.degrees(45))
                                }
                            }
                        }
                    }
                }
                Spacer()
            }.padding(.leading))
    }
}

#Preview {
    HeroTitleView(heroID: 1, primaryAttribute: "str", displayName: "Anti-Mage", heroComplexity: 2)
}
