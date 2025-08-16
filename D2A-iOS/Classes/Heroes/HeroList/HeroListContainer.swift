//
//  HeroListContainer.swift
//  D2A
//
//  Created by Shibo Tong on 9/8/2025.
//

import SwiftUI

struct HeroListContainer: View {
    
    @EnvironmentObject var constantsController: ConstantsController
    
    @FetchRequest(entity: Hero.entity(), sortDescriptors: [])
    private var heroes: FetchedResults<Hero>
    
    private var sortedHeroes: [Hero] {
        return Array(heroes).sorted(by: { $0.heroNameLocalized < $1.heroNameLocalized })
    }
    
    var body: some View {
        if heroes.isEmpty && constantsController.isLoading {
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
