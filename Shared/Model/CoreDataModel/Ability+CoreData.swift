//
//  Ability.swift
//  D2A
//
//  Created by Shibo Tong on 10/11/2024.
//

import Foundation

extension Ability {
    func update(abilityID: Int, name: String, ability: AbilityCodable) {
        updateIfNotEqual(entity: self, path: \.abilityID, value: Int16(abilityID))
        updateIfNotEqual(entity: self, path: \.behavior, value: ability.behavior?.transformString())
        updateIfNotEqual(entity: self, path: \.bkbPierce, value: ability.bkbPierce?.transformString())
        updateIfNotEqual(entity: self, path: \.coolDown, value: ability.coolDown?.transformString())
        updateIfNotEqual(entity: self, path: \.damageType, value: ability.damageType?.transformString())
        updateIfNotEqual(entity: self, path: \.desc, value: ability.desc)
        updateIfNotEqual(entity: self, path: \.dispellable, value: ability.dispellable?.transformString())
        updateIfNotEqual(entity: self, path: \.dname, value: ability.dname)
        updateIfNotEqual(entity: self, path: \.lore, value: ability.lore)
        updateIfNotEqual(entity: self, path: \.manaCost, value: ability.manaCost?.transformString())
        updateIfNotEqual(entity: self, path: \.name, value: name)
        updateIfNotEqual(entity: self, path: \.targetTeam, value: ability.targetTeam?.transformString())
        updateIfNotEqual(entity: self, path: \.targetType, value: ability.targetType?.transformString())
    }
}
