//
//  SaveHero.swift
//  D2A
//
//  Created by Shibo Tong on 10/11/2024.
//

import Foundation
import CoreData

extension Hero {
    func updateHero(model: HeroCodable) {
        updateIfNotEqual(entity: self, path: \.heroID, value: Int16(model.heroID))
        updateIfNotEqual(entity: self, path: \.primaryAttr, value: model.primaryAttr)
        updateIfNotEqual(entity: self, path: \.attackType, value: model.attackType)
        updateIfNotEqual(entity: self, path: \.baseHealth, value: model.baseHealth)
        updateIfNotEqual(entity: self, path: \.baseHealthRegen, value: model.baseHealthRegen)
        updateIfNotEqual(entity: self, path: \.baseMana, value: model.baseMana)
        updateIfNotEqual(entity: self, path: \.baseManaRegen, value: model.baseManaRegen)
        updateIfNotEqual(entity: self, path: \.baseArmor, value: model.baseArmor)
        updateIfNotEqual(entity: self, path: \.baseMr, value: model.baseMr)
        updateIfNotEqual(entity: self, path: \.baseAttackMin, value: model.baseAttackMin)
        updateIfNotEqual(entity: self, path: \.baseAttackMax, value: model.baseAttackMax)
        
        updateIfNotEqual(entity: self, path: \.baseStr, value: model.baseStr)
        updateIfNotEqual(entity: self, path: \.baseAgi, value: model.baseAgi)
        updateIfNotEqual(entity: self, path: \.baseInt, value: model.baseInt)
        updateIfNotEqual(entity: self, path: \.gainStr, value: model.strGain)
        updateIfNotEqual(entity: self, path: \.gainAgi, value: model.agiGain)
        updateIfNotEqual(entity: self, path: \.gainInt, value: model.intGain)
        
        updateIfNotEqual(entity: self, path: \.attackRange, value: model.attackRange)
        updateIfNotEqual(entity: self, path: \.projectileSpeed, value: model.projectileSpeed)
        updateIfNotEqual(entity: self, path: \.attackRate, value: model.attackRate)
        updateIfNotEqual(entity: self, path: \.moveSpeed, value: model.moveSpeed)
        updateIfNotEqual(entity: self, path: \.turnRate, value: model.turnRate ?? 0.6)
    }
}
