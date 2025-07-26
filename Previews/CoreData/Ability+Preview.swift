//
//  Ability+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 27/7/2025.
//

import Foundation

extension Ability {
    static let preview: Ability = {
        let context = PersistanceProvider.preview.container.viewContext
        let ability = Ability.fetchByName(name: "antimage_blink", context: context)
        return ability!
    }()
    
    static let blink: Ability = {
        loadAbility(name: "antimage_blink")
    }()
    
    static let manaBreak: Ability = {
        loadAbility(name: "antimage_mana_break")
    }()
    
    static func loadAbility(name: String) -> Ability {
        let context = PersistanceProvider.preview.container.viewContext
        let ability = Ability.fetchByName(name: name, context: context)
        return ability!
    }
}
