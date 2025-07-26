//
//  GameMode+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 26/7/2025.
//

extension GameMode {
    static let preview: GameMode = {
        let context = PersistanceProvider.preview.container.viewContext
        let modes = try! context.fetch(GameMode.fetchRequest())
        return modes.first!
    }()
}
