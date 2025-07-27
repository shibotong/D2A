//
//  HeroDetailViewV2.swift
//  D2A
//
//  Created by Shibo Tong on 27/7/2025.
//

import SwiftUI

struct HeroDetailViewV2: View {
    
    let hero: Hero
    
    var body: some View {
        Text(hero.abilities?.description ?? "No abilities")
    }
}

#if DEBUG
#Preview {
    HeroDetailViewV2(hero: Hero.antimage)
}
#endif
