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
    let heroID: Int
    let type: HeroImageType
    
    var body: some View {
        if heroID == 0 && type == .icon {
            Circle()
                .foregroundColor(Color.label.opacity(0.3))
        } else {
            Image(searchHeroImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    private func searchHeroImage() -> String {
        return "\(heroID.description)_\(type.rawValue)"
    }
}

#Preview {
    HeroImageView(heroID: 1, type: .full)
}
