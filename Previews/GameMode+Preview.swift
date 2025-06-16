//
//  GameMode+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 9/6/2025.
//

extension GameMode {
    static let preview: GameMode = {
        let context = PersistanceProvider.previewContext
        let mode = GameMode(context: context)
        mode.id = 1
        mode.name = "game_mode_unknown"
        mode.balanced = true
        try! context.save()
        return mode
    }()
}
