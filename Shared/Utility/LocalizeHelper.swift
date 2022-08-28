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

            //MARK: 9. Mirana
        case "special_bonus_unique_mirana_1":
            let prefix = "+"
            let suffix = " Leap Attack Speed"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Leap Attack Speed")
            }
        case "special_bonus_unique_mirana_2":
            let prefix = "+"
            let suffix = " Multishot Sacred Arrows"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Multishot Sacred Arrows")
            }
        case "special_bonus_unique_mirana_3":
            let prefix = "-"
            let suffix = "s Sacred Arrow cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Sacred Arrow cooldown")
            }
        case "special_bonus_unique_mirana_4":
            let prefix = "-"
            let suffix = "s Moonlight Shadow Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Moonlight Shadow Cooldown")
            }
        case "special_bonus_unique_mirana_5":
            let prefix = "Moonlight Shadow gives +"
            let suffix = " Evasion"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("Moonlight Shadow gives +\(value) Evasion")
            }
        case "special_bonus_unique_mirana_6":
            let prefix = "+"
            let suffix = " Leap Distance"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Leap Distance")
            }
        case "special_bonus_unique_mirana_7":
            let prefix = "+"
            let suffix = " Starstorm Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Starstorm Damage")
            }

            //MARK: 10. Morphling
        case "special_bonus_unique_morphling_1":
            let prefix = "+"
            let suffix = " Waveform Range"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Waveform Range")
            }
        case "special_bonus_unique_morphling_2":
            let prefix = "-"
            let suffix = " Morph Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value) Morph Cooldown")
            }
        case "special_bonus_unique_morphling_3":
            let prefix = "+"
            let suffix = " Multishot Adaptive Strike"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("\(value) Multishot Adaptive Strike")
            }
        case "special_bonus_unique_morphling_4":
            let prefix = ""
            let suffix = "Waveform Attacks Targets"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                return LocalizedStringKey("Waveform Attacks Targets")
            }
        case "special_bonus_unique_morphling_5":
            let prefix = ""
            let suffix = "Morph Targets Allies"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                return LocalizedStringKey("Morph Targets Allies")
            }
        case "special_bonus_unique_morphling_6":
            let prefix = ""
            let suffix = " Waveform Charges"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("\(value) Waveform Charges")
            }
        case "special_bonus_unique_morphling_7":
            let prefix = "-"
            let suffix = "s Adaptive Strike Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Adaptive Strike Cooldown")
            }
        case "special_bonus_unique_morphling_8":
            let prefix = "+"
            let suffix = "s Morph Duration"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value)s Morph Duration")
            }
        case "special_bonus_unique_morphling_9":
            let prefix = "-"
            let suffix = " Adaptive Strike Armor Reduction"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value) Adaptive Strike Armor Reduction")
            }
        case "special_bonus_unique_morphling_10":
            let prefix = "+"
            let suffix = "s Adaptive Strike Stun Duration"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value)s Adaptive Strike Stun Duration")
            }

            // MARK: 11. Shadow Fiend
        case "special_bonus_unique_nevermore_1":
            let prefix = "+"
            let suffix = " Damage Per Soul"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Damage Per Soul")
            }
        case "special_bonus_unique_nevermore_2":
            let prefix = "+"
            let suffix = " Shadowraze Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Shadowraze Damage")
            }
        case "special_bonus_unique_nevermore_3":
            let prefix = ""
            let suffix = "Presence Aura Affects Building"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                return LocalizedStringKey("Presence Aura Affects Building")
            }
        case "special_bonus_unique_nevermore_4":
            let prefix = "-"
            let suffix = "s Requiem of Souls Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Requiem of Souls Cooldown")
            }
        case "special_bonus_unique_nevermore_5":
            let prefix = "-"
            let suffix = " Presence Aura Armor"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value) Presence Aura Armor")
            }
        case "special_bonus_unique_nevermore_6":
            let prefix = "+"
            let suffix = "s Requiem Fear per line"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value)s Requiem Fear per line")
            }
        case "special_bonus_unique_nevermore_7":
            let prefix = "+"
            let suffix = " Shadowraze Stack Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Shadowraze Stack Damage")
            }
        case "special_bonus_unique_nevermore_raze_procsattacks":
            let prefix = ""
            let suffix = "Shadowraze Applies Attack Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                return LocalizedStringKey("Shadowraze Applies Attack Damage")
            }
        case "special_bonus_unique_nevermore_shadowraze_cooldown":
            let prefix = "-"
            let suffix = "s Shadowraze Cooldown"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Shadowraze Cooldown")
            }

            // MARK: 12. Phantom Lancer
            case "special_bonus_unique_phantom_lancer":
            let prefix = "+"
            let suffix = " Phantom Rush Range"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Phantom Rush Range")
            }
            case "special_bonus_unique_phantom_lancer_2":
            let prefix = "+"
            let suffix = "s Phantom Rush Bonus Agi Duration"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value)s Phantom Rush Bonus Agi Duration")
            }
            case "special_bonus_unique_phantom_lancer_3":
            let prefix = "+"
            let suffix = " Max Juxtapose Illusions"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Max Juxtapose Illusions")
            }
            case "special_bonus_unique_phantom_lancer_4":
            let prefix = "-"
            let suffix = "s Doppelganger CD"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Doppelganger CD")
            }
            case "special_bonus_unique_phantom_lancer_5":
            let prefix = "-"
            let suffix = "s Spirit Lance CD"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("-\(value)s Spirit Lance CD")
            }
            case "special_bonus_unique_phantom_lancer_6":
            let prefix = "+"
            let suffix = " Juxtapose Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Juxtapose Damage")
            }
            case "special_bonus_unique_phantom_lancer_7":
            let prefix = "+"
            let suffix = " Spirit Lance Multishot"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Spirit Lance Multishot")
            }
            case "special_bonus_unique_phantom_lancer_doppel_illusion2_amt":
            let prefix = "+"
            let suffix = " Doppelganger Illusion"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Doppelganger Illusion")
            }
            case "special_bonus_unique_phantom_lancer_lance_damage":
            let prefix = "+"
            let suffix = " Spirit Lance Damage"
            if dname.hasPrefix(prefix) && dname.hasSuffix(suffix) {
                let value = dname.fetchTalentValue(prefix: prefix, suffix: suffix)
                return LocalizedStringKey("+\(value) Spirit Lance Damage")
            }

//            // TODO: 13. Puck
//            "-10s Dream Coil Cooldown" = ""; // special_bonus_unique_puck
//            "-4s Waning Rift Cooldown" = ""; // special_bonus_unique_puck_2
//            "Dream Coil Rapid Fire" = ""; // special_bonus_unique_puck_3
//            "+{s:bonus_coil_stun_duration}s Dream Coil Stun Duration" = ""; // special_bonus_unique_puck_4
//            "Dream Coil Pierces Magic Immunity" = ""; // special_bonus_unique_puck_5
//            "+{s:bonus_damage} Waning Rift Damage" = ""; // special_bonus_unique_puck_6
//            "+{s:bonus_silence_duration}s Waning Rift Silence Duration" = ""; // special_bonus_unique_puck_7
//            "-{s:bonus_AbilityCooldown}s Illusory Orb Cooldown" = ""; // special_bonus_unique_puck_8
//            "+{s:bonus_damage} Illusory Orb Damage" = ""; // special_bonus_unique_puck_orb_damage
//            "+{s:bonus_coil_break_damage} Initial/Break Dream Coil Damage" = ""; // special_bonus_unique_puck_coil_damage
//
//            // TODO: 14. Pudge
//            "1.5x Flesh Heap Stack Str and Damage Block bonuses" = ""; // special_bonus_unique_pudge_1
//            "+30 Rot Damage" = ""; // special_bonus_unique_pudge_2
//            "1.8x Dismember Damage/Heal" = ""; // special_bonus_unique_pudge_3
//            "-16% Rot Slow" = ""; // special_bonus_unique_pudge_4
//            "-{s:bonus_AbilityCooldown}s Meat Hook Cooldown" = ""; // special_bonus_unique_pudge_5
//            "+0.8s Dismember Duration" = ""; // special_bonus_unique_pudge_6
//            "+{s:bonus_damage} Meat Hook Damage" = ""; // special_bonus_unique_pudge_7
//
//            // TODO: 15. Razor
//            "+{s:bonus_drain_rate} Static Link Damage Steal" = ""; // special_bonus_unique_razor
//            "0.1s Eye of the Storm Strike Interval" = ""; // special_bonus_unique_razor_2
//            "+{s:bonus_drain_duration}s Static Link Drain Duration" = ""; // special_bonus_unique_razor_3
//            "+{s:bonus_damage_min} Plasma Field Damage" = ""; // special_bonus_unique_razor_4
//            "+21% Storm Surge Move Speed" = ""; // special_bonus_unique_razor_5
//            "2 Static Link Charges" = ""; // special_bonus_unique_razor_6
//            "Creates A Second Plasma Field Delayed By {s:bonus_second_ring_delay}s" = ""; // special_bonus_unique_razor_plasmafield_second_ring
//            "Static Link Steals Attack Speed" = ""; // special_bonus_unique_razor_static_link_aspd
//
//            // TODO: 16. Sand King
//            "+5 Epicenter Pulses" = ""; // special_bonus_unique_sand_king
//            "+20 Sand Storm Damage Per Second" = ""; // special_bonus_unique_sand_king_2
//            "+125 Sand Storm Radius" = ""; // special_bonus_unique_sand_king_3
//            "35% Sand Storm Slow and Blind" = ""; // special_bonus_unique_sand_king_4
//            "+{s:bonus_epicenter_radius} Epicenter Radius" = ""; // special_bonus_unique_sand_king_5
//            "+12% Caustic Finale Slow" = ""; // special_bonus_unique_sand_king_6
//            "-2s Burrowstrike Cooldown" = ""; // special_bonus_unique_sand_king_7
//            "+100 Caustic Finale Damage" = ""; // special_bonus_unique_sand_king_8
//            "+{s:bonus_burrow_duration}s Burrowstrike Stun" = ""; // special_bonus_unique_sand_king_burrowstrike_stun
//
//            // TODO: 17. Storm Spirit
//            "+0.4s Electric Vortex" = ""; // special_bonus_unique_storm_spirit
//            "+6 Ball Lightning Damage" = ""; // special_bonus_unique_storm_spirit_2
//            "Overload Pierces Immunity" = ""; // special_bonus_unique_storm_spirit_3
//            "500 Distance Auto Remnant in Ball Lightning" = ""; // special_bonus_unique_storm_spirit_4
//            "+50 Static Remnant Damage" = ""; // special_bonus_unique_storm_spirit_5
//            "+24 Overload Damage" = ""; // special_bonus_unique_storm_spirit_6
//            "2x Overload Attack Bounce" = ""; // special_bonus_unique_storm_spirit_7
//            "-1.25s Static Remnant Cooldown" = ""; // special_bonus_unique_storm_spirit_8
//
//            // TODO: 18. Sven
//            "-4s Storm Hammer Cooldown" = ""; // special_bonus_unique_sven
//            "+50% God's Strength Damage" = ""; // special_bonus_unique_sven_2
//            "-15s God's Strength Cooldown" = ""; // special_bonus_unique_sven_3
//            "+1.25s Storm Hammer Stun Duration" = ""; // special_bonus_unique_sven_4
//            "+3s Warcry Duration" = ""; // special_bonus_unique_sven_5
//            "+8% Warcry Movement Speed" = ""; // special_bonus_unique_sven_6
//            "+10 Warcry Armor" = ""; // special_bonus_unique_sven_7
//            "+25% Great Cleave Damage" = ""; // special_bonus_unique_sven_8
//
//            // TODO: 19. Tiny
//            "+80 Avalanche Damage" = ""; // special_bonus_unique_tiny
//            "2 Toss Charges" = ""; // special_bonus_unique_tiny_2
//            "-8s Avalanche Cooldown" = ""; // special_bonus_unique_tiny_3
//            "-7s Tree Grab CD" = ""; // special_bonus_unique_tiny_4
//            "Toss Requires No Target" = ""; // special_bonus_unique_tiny_5
//            "+5 Tree Grab Attack Charges" = ""; // special_bonus_unique_tiny_6
//            "+40% Grow Bonus Damage With Tree" = ""; // special_bonus_unique_tiny_7
//
//            // TODO: 20. Vengeful Spirit
//            "+{s:bonus_magic_missile_damage} Magic Missile Damage" = ""; // special_bonus_unique_vengeful_spirit_1
//            "+16% Vengeance Aura Base Damage Bonus" = ""; // special_bonus_unique_vengeful_spirit_2
//            "Magic Missile Pierces Spell Immunity" = ""; // special_bonus_unique_vengeful_spirit_3
//            "-2 Wave of Terror Armor" = ""; // special_bonus_unique_vengeful_spirit_4
//            "-2s Magic Missile Cooldown" = ""; // special_bonus_unique_vengeful_spirit_5
//            "-6s Wave of Terror Cooldown" = ""; // special_bonus_unique_vengeful_spirit_6
//            "Vengeance Aura Illusion Casts Spells" = ""; // special_bonus_unique_vengeful_spirit_7
//            "+100 Vengeance Aura Attack Range" = ""; // special_bonus_unique_vengeful_spirit_8
//            "-15s Nether Swap Cooldown" = ""; // special_bonus_unique_vengeful_spirit_9
//            "+{s:bonus_AbilityCastRange} Magic Missile Cast Range" = ""; // special_bonus_unique_vengeful_spirit_missile_castrange
//            "+{s:bonus_damage} Nether Swap Enemy Damage" = ""; // special_bonus_unique_vengeful_spirit_swap_damage

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


