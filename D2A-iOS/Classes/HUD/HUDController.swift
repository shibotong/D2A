//
//  HUDController.swift
//  D2A
//
//  Created by Shibo Tong on 4/11/2025.
//

import Foundation

#if DEBUG
class HUDController: ObservableObject {
    
    static var shared = HUDController()
    
    @Published var huds: [HUDProgress]
    
    init(huds: [HUDProgress] = []) {
        self.huds = huds
    }
    
    @MainActor
    func createHUD(title: String, total: Int) {
        let hudsTitle = huds.map(\.title)
        guard !hudsTitle.contains(title) else {
            logWarn("HUD already exists: \(title)", category: .hud)
            return
        }
        let newHUD = HUDProgress(title: title, total: total, current: 0)
        huds.append(newHUD)
    }
    
    @MainActor
    func updateHUD(title: String) {
        guard let hudIndex = huds.firstIndex(where: { $0.title == title }) else {
            logError("Cannot find hud for \(title)", category: .hud)
            return
        }
        let hud = huds[hudIndex]
        if hud.update() {
            huds.remove(at: hudIndex)
        }
    }
}

class HUDProgress: ObservableObject {
    
    let title: String
    let total: Int
    
    @Published var current: Int
    
    init(title: String, total: Int, current: Int) {
        self.title = title
        self.total = total
        self.current = current
    }
    
    func update() -> Bool {
        current += 1
        return current >= total
    }
}
#endif
