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

            //MARK: 2. Axe
        case "special_bonus_unique_axe":
            let prefix = ""
            let suffix = "x Battle Hunger Armor Multiplier"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("\(value)x Battle Hunger Armor Multiplier")
            }
        case "special_bonus_unique_axe_2":
            let prefix = "+"
            let suffix = " Berserker's Call AoE"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Berserker's Call AoE")
            }
        case "special_bonus_unique_axe_3":
            let prefix = "+"
            let suffix = " Bonus Armor per Culling Blade Stack"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Bonus Armor per Culling Blade Stack")
            }
        case "special_bonus_unique_axe_4":
            let prefix = "+"
            let suffix = " Counter Helix Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Counter Helix Damage")
            }
        case "special_bonus_unique_axe_5":
            let prefix = "+"
            let suffix = " Culling Blade Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Culling Blade Damage")
            }
        case "special_bonus_unique_axe_6":
            let prefix = "+"
            let suffix = " Battle Hunger Slow"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Battle Hunger Slow")
            }
        case "special_bonus_unique_axe_7":
            let prefix = "+"
            let suffix = " Berseker's Call Armor"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Berseker's Call Armor")
            }
        case "special_bonus_unique_axe_8":
            let prefix = "+"
            let suffix = " Movement Speed per active Battle Hunger"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Movement Speed per active Battle Hunger")
            }

            //MARK: 3. Bane
        case "special_bonus_unique_bane_1":
            let prefix = "+"
            let suffix = " Enfeeble Attack Speed Reduction"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Enfeeble Attack Speed Reduction")
            }
        case "special_bonus_unique_bane_2":
            let prefix = "+"
            let suffix = " Brain Sap Damage/Heal"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Brain Sap Damage/Heal")
            }
        case "special_bonus_unique_bane_3":
            let prefix = "+"
            let suffix = "s Fiend's Grip Duration"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value)s Fiend's Grip Duration")
            }
        case "special_bonus_unique_bane_4":
            let prefix = ""
            let suffix = "Enfeeble Steals Attack Speed"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                return LocalizedStringKey("Enfeeble Steals Attack Speed")
            }
        case "special_bonus_unique_bane_5":
            let prefix = "-"
            let suffix = "s Nightmare Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Nightmare Cooldown")
            }
        case "special_bonus_unique_bane_6":
            let prefix = "-"
            let suffix = " Enfeeble Regen Reduction"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value) Enfeeble Regen Reduction")
            }
        case "special_bonus_unique_bane_7":
            let prefix = ""
            let suffix = "Brain Sap Pure and Pierces Immunity"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                return LocalizedStringKey("Brain Sap Pure and Pierces Immunity")
            }
        case "special_bonus_unique_bane_8":
            let prefix = "-"
            let suffix = "s Brain Sap Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Brain Sap Cooldown")
            }
        case "special_bonus_unique_bane_9":
            let prefix = "+"
            let suffix = " Fiend's Grip Max Mana Drain"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Fiend's Grip Max Mana Drain")
            }
        case "special_bonus_unique_bane_10":
            let prefix = ""
            let suffix = "Nightmare Damage Heals Bane"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                return LocalizedStringKey("Nightmare Damage Heals Bane")
            }
        case "special_bonus_unique_bane_11":
            let prefix = "+"
            let suffix = " Enfeeble Cast Range Reduction"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Enfeeble Cast Range Reduction")
            }

            //MARK: BloodSeeker
        case "special_bonus_unique_bloodseeker":
            let prefix = "-"
            let suffix = "s Blood Rite Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Blood Rite Cooldown")
            }
        case "special_bonus_unique_bloodseeker_2":
            let prefix = "+"
            let suffix = " Blood Rite Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Blood Rite Damage")
            }
        case "special_bonus_unique_bloodseeker_3":
            let prefix = "+"
            let suffix = " Rupture Cast Range"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Rupture Cast Range")
            }
        case "special_bonus_unique_bloodseeker_4":
            let prefix = "+"
            let suffix = " Max Thirst MS"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Max Thirst MS")
            }
        case "special_bonus_unique_bloodseeker_5":
            let prefix = "+"
            let suffix = " Bloodrage Attack Speed"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Bloodrage Attack Speed")
            }
        case "special_bonus_unique_bloodseeker_6":
            let prefix = "+"
            let suffix = " Bloodrage Spell Amplification"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Bloodrage Spell Amplification")
            }
        case "special_bonus_unique_bloodseeker_7":
            let prefix = "+"
            let suffix = " Rupture Initial Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Rupture Initial Damage")
            }
        case "special_bonus_unique_bloodseeker_rupture_charges":
            let prefix = ""
            let suffix = " Rupture Charges"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("\(value) Rupture Charges")
            }

            //MARK: 5. Crystal Maiden
        case "special_bonus_unique_crystal_maiden_1":
            let prefix = "+"
            let suffix = "s Frostbite Duration"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value)s Frostbite Duration")
            }
        case "special_bonus_unique_crystal_maiden_2":
            let prefix = "+"
            let suffix = " Crystal Nova Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Crystal Nova Damage")
            }
        case "special_bonus_unique_crystal_maiden_3":
            let prefix = "+"
            let suffix = " Freezing Field Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Freezing Field Damage")
            }
        case "special_bonus_unique_crystal_maiden_4":
            let prefix = "+"
            let suffix = " Arcane Aura Base Mana Regeneration"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Arcane Aura Base Mana Regeneration")
            }
        case "special_bonus_unique_crystal_maiden_5":
            let prefix = "-"
            let suffix = "s Crystal Nova Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Crystal Nova Cooldown")
            }
        case "special_bonus_unique_crystal_maiden_6":
            let prefix = "+"
            let suffix = " Crystal Nova AoE"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Crystal Nova AoE")
            }
        case "special_bonus_unique_crystal_maiden_frostbite_castrange":
            let prefix = "+"
            let suffix = " Frostbite Cast Range"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Frostbite Cast Range")
            }

            //MARK: 6. Drow Ranger
        case "special_bonus_unique_drow_ranger_1":
            let prefix = "+"
            let suffix = " Multishot Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Multishot Damage")
            }
        case "special_bonus_unique_drow_ranger_2":
            let prefix = "+"
            let suffix = " Frost Arrow Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Frost Arrow Damage")
            }
        case "special_bonus_unique_drow_ranger_3":
            let prefix = "+"
            let suffix = " Marksmanship Chance"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Marksmanship Chance")
            }
        case "special_bonus_unique_drow_ranger_4":
            let prefix = "+"
            let suffix = " Gust Width"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Gust Width")
            }
        case "special_bonus_unique_drow_ranger_5":
            let prefix = "+"
            let suffix = " Gust Blind"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Gust Blind")
            }
        case "special_bonus_unique_drow_ranger_6":
            let prefix = "-"
            let suffix = "s Multishot Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Multishot Cooldown")
            }
        case "special_bonus_unique_drow_ranger_7":
            let prefix = "-"
            let suffix = "s Gust Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Gust Cooldown")
            }
        case "special_bonus_unique_drow_ranger_8":
            let prefix = "+"
            let suffix = " Multishot Waves"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Multishot Waves")
            }
        case "special_bonus_unique_drow_ranger_gust_invis":
            let prefix = ""
            let suffix = "Gust Reveals Invisible Units"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                return LocalizedStringKey("Gust Reveals Invisible Units")
            }
        case "special_bonus_unique_drow_ranger_gust_selfmovespeed":
            let prefix = "+"
            let suffix = " Gust Self Movement Speed"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Gust Self Movement Speed")
            }

            //MARK: 7. Earch SHaker
        case "special_bonus_unique_earthshaker":
            let prefix = "-"
            let suffix = "s Enchant Totem Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Enchant Totem Cooldown")
            }
        case "special_bonus_unique_earthshaker_2":
            let prefix = "+"
            let suffix = " Echo Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Echo Damage")
            }
        case "special_bonus_unique_earthshaker_3":
            let prefix = "+"
            let suffix = " Fissure Range"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Fissure Range")
            }
        case "special_bonus_unique_earthshaker_4":
            let prefix = "+"
            let suffix = " Fissure Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Fissure Damage")
            }
        case "special_bonus_unique_earthshaker_5":
            let prefix = "+"
            let suffix = " Aftershock Range"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Aftershock Range")
            }
        case "special_bonus_unique_earthshaker_6":
            let prefix = "+"
            let suffix = " Aftershock Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Aftershock Damage")
            }
        case "special_bonus_unique_earthshaker_totem_damage":
            let prefix = "+"
            let suffix = " Enchant Totem Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Enchant Totem Damage")
            }

            //MARK: 8. Juggernaut
        case "special_bonus_unique_juggernaut":
            let prefix = "+"
            let suffix = " Blade Fury Radius"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Blade Fury Radius")
            }
        case "special_bonus_unique_juggernaut_2":
            let prefix = "+"
            let suffix = " Healing Ward Health"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Healing Ward Health")
            }
        case "special_bonus_unique_juggernaut_3":
            let prefix = "+"
            let suffix = " Blade Fury DPS"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Blade Fury DPS")
            }
        case "special_bonus_unique_juggernaut_4":
            let prefix = "+"
            let suffix = "s Blade Fury Duration"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value)s Blade Fury Duration")
            }
        case "special_bonus_unique_juggernaut_5":
            let prefix = "-"
            let suffix = "s Healing Ward Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Healing Ward Cooldown")
            }
        case "special_bonus_unique_juggernaut_blade_dance_lifesteal":
            let prefix = "+"
            let suffix = " Blade Dance Lifesteal"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Blade Dance Lifesteal")
            }
        case "special_bonus_unique_juggernaut_omnislash_duration":
            let prefix = "+"
            let suffix = "s Omnislash Duration"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value)s Omnislash Duration")
            }
        case "special_bonus_unique_juggernaut_omnislash_cast_range":
            let prefix = "+"
            let suffix = " Omnislash Cast Range"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Omnislash Cast Range")
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


