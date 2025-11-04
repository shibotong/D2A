//
//  HUDProgressViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 4/11/2025.
//

import Foundation

#if DEBUG
class HUDProgressViewModel: ObservableObject {
    
    static var shared = HUDProgressViewModel()
    
    @Published var showHeroHUD: Bool
    @Published var heroTotal: Int
    @Published var heroCurrent: Int
    
    init(heroHUD: Bool = false, heroTotal: Int = 0, heroCurrent: Int = 0) {
        self.showHeroHUD = heroHUD
        self.heroTotal = heroTotal
        self.heroCurrent = heroCurrent
    }
    
    @MainActor
    func setupHUD(heroTotal: Int, heroCurrent: Int = 0) {
        guard heroTotal > 0 else {
            logWarn("total amount of hero is less than 0", category: .hud)
            return
        }
        showHeroHUD = true
        self.heroTotal = heroTotal
        self.heroCurrent = heroCurrent
    }
    
    @MainActor
    func addHeroProgress() {
        heroCurrent += 1
        if heroCurrent >= heroTotal {
            showHeroHUD = false
        }
    }
}
#endif
