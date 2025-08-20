//
//  HeroListContainer.swift
//  D2A
//
//  Created by Shibo Tong on 9/8/2025.
//

import SwiftUI

struct HeroListContainer: View {
    
    @EnvironmentObject var constantsController: ConstantsController
    
    private var sortedHeroes: [Hero] {
        return constantsController.allHeroes.sorted(by: { $0.heroNameLocalized < $1.heroNameLocalized })
    }
    
    var body: some View {
        if constantsController.allHeroes.isEmpty && constantsController.isLoading {
            ProgressView()
        } else {
            HeroListView(heroes: sortedHeroes)
        }
    }
}

#Preview {
    HeroListContainer()
        .environmentObject(ConstantsController.preview)
}
