//
//  LocalizeHelper.swift
//  App
//
//  Created by Shibo Tong on 26/8/2022.
//

import Foundation
import SwiftUI

class LocalizeHelper {
    static func localizationString(_ ability: Ability, key: String) -> LocalizedStringKey {
        guard let dname = ability.dname else {
            return LocalizedStringKey("")
        }
        switch key {
            //MARK: 1. Anti-mage
        case "special_bonus_unique_antimage":
            let prefix = "-"
            let suffix = "s Blink Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Blink Cooldown")
            }
        case "special_bonus_unique_antimage_2":
            let prefix = "-"
            let suffix = "s Mana Void Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Mana Void Cooldown")
            }
        case "special_bonus_unique_antimage_3":
            let prefix = "+"
            let suffix = " Blink Cast Range"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Blink Cast Range")
            }
        case "special_bonus_unique_antimage_4":
            let prefix = "+"
            let suffix = " Counterspell Magic Resistance"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Counterspell Magic Resistance")
            }
        case "special_bonus_unique_antimage_5":
            let prefix = ""
            let suffix = "Blink Uncontrollable Illusion"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                return LocalizedStringKey("Blink Uncontrollable Illusion")
            }
        case "special_bonus_unique_antimage_6":
            let prefix = "+"
            let suffix = " Mana Void Damage Multiplier"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Mana Void Damage Multiplier")
            }
        case "special_bonus_unique_antimage_7":
            let prefix = "+"
            let suffix = " Max Mana Mana Burn"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Max Mana Mana Burn")
            }
        case "special_bonus_unique_antimage_8":
            let prefix = "+"
            let suffix = "s Mana Void Stun"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value)s Mana Void Stun")
            }
        case "special_bonus_unique_antimage_manavoid_aoe":
            let prefix = "+"
            let suffix = " Mana Void Radius"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Mana Void Radius")
            }

            //MARK: 68. Ancient Apparition
        case "special_bonus_unique_ancient_apparition_1":
            let prefix = "+"
            let suffix = " Cold Feet Breaking distance"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Cold Feet Breaking distance")
            }
        case "special_bonus_unique_ancient_apparition_2":
            let prefix = "+"
            let suffix = " Chilling Touch Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Chilling Touch Damage")
            }
        case "special_bonus_unique_ancient_apparition_3":
            let prefix = "-"
            let suffix = "s Ice Vortex Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Ice Vortex Cooldown")
            }
        case "special_bonus_unique_ancient_apparition_4":
            let prefix = ""
            let suffix = " Ice Vortex Slow/Resistance"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("\(value) Ice Vortex Slow/Resistance")
            }
        case "special_bonus_unique_ancient_apparition_5":
            let prefix = "+"
            let suffix = " Ice Blast Kill Threshold"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Ice Blast Kill Threshold")
            }
        case "special_bonus_unique_ancient_apparition_6":
            let prefix = ""
            let suffix = " AoE Cold Feet"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("\(value) AoE Cold Feet")
            }
        case "special_bonus_unique_ancient_apparition_7":
            let prefix = "+"
            let suffix = " Chilling Touch Attack Range"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Chilling Touch Attack Range")
            }
        case "special_bonus_unique_ancient_apparition_8":
            let prefix = "+"
            let suffix = " Cold Feet Damage Per Second"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Cold Feet Damage Per Second")
            }

            //MARK: 73. Alchemist
        case "special_bonus_unique_alchemist":
            let prefix = "+"
            let suffix = " Unstable Concoction Radius"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Unstable Concoction Radius")
            }
        case "special_bonus_unique_alchemist_2":
            let prefix = "+"
            let suffix = " Unstable Concoction Max Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Unstable Concoction Max Damage")
            }
        case "special_bonus_unique_alchemist_3":
            let prefix = ""
            let suffix = "Acid Spray grants armor to allies"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                return LocalizedStringKey("Acid Spray grants armor to allies")
            }
        case "special_bonus_unique_alchemist_4":
            let prefix = "+"
            let suffix = " Chemical Rage Regeneration"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Chemical Rage Regeneration")
            }
        case "special_bonus_unique_alchemist_5":
            let prefix = "+"
            let suffix = " Acid Spray Armor Reduction"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Acid Spray Armor Reduction")
            }
        case "special_bonus_unique_alchemist_6":
            let prefix = "+"
            let suffix = " Chemical Rage Movement Speed"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Chemical Rage Movement Speed")
            }
        case "special_bonus_unique_alchemist_7":
            let prefix = "+"
            let suffix = " Damage per Greevil Greed stack"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Damage per Greevil Greed stack")
            }
        case "special_bonus_unique_alchemist_8":
            let prefix = "-"
            let suffix = "s Chemical Rage Base Attack Time"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Chemical Rage Base Attack Time")
            }
            
            //MARK: 102. Abaddon
        case "special_bonus_unique_abaddon":
            let prefix = "+"
            let suffix = " Aphotic Shield Health"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Aphotic Shield Health")
            }
        case "special_bonus_unique_abaddon_2":
            let prefix = "+"
            let suffix = " Mist Coil Heal/Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Mist Coil Heal/Damage")
            }
        case "special_bonus_unique_abaddon_3":
            let prefix = "-"
            let suffix = " Curse of Avernus Attacks Required"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value) Curse of Avernus Attacks Required")
            }
        case "special_bonus_unique_abaddon_4":
            let prefix = ""
            let suffix = " AoE Mist Coil"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("\(value) AoE Mist Coil")
            }
        case "special_bonus_unique_abaddon_5":
            let prefix = "-"
            let suffix = "s Borrowed Time Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Borrowed Time Cooldown")
            }
        case "special_bonus_unique_abaddon_6":
            let prefix = "-"
            let suffix = " Curse of Avernus Movement Slow"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value) Curse of Avernus Movement Slow")
            }

            //MARK: 113. Arc Warden
        case "special_bonus_unique_arc_warden":
            let prefix = "+"
            let suffix = " Spark Wraith Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Spark Wraith Damage")
            }
        case "special_bonus_unique_arc_warden_2":
            let prefix = "+"
            let suffix = " Flux Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Flux Damage")
            }
        case "special_bonus_unique_arc_warden_3":
            let prefix = "+"
            let suffix = " Magnetic Field Attack Speed"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Magnetic Field Attack Speed")
            }
        case "special_bonus_unique_arc_warden_4":
            let prefix = "+"
            let suffix = "s Flux Duration"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value)s Flux Duration")
            }
        case "special_bonus_unique_arc_warden_5":
            let prefix = "+"
            let suffix = " Flux Cast Range"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Flux Cast Range")
            }
        case "special_bonus_unique_arc_warden_6":
            let prefix = "+"
            let suffix = "s Tempest Double Duration"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value)s Tempest Double Duration")
            }
        case "special_bonus_unique_arc_warden_7":
            let prefix = "+"
            let suffix = " Tempest Double Cooldown Reduction"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Tempest Double Cooldown Reduction")
            }
        default:
            return LocalizedStringKey(dname)
        }
        return LocalizedStringKey(dname)
    }
}


