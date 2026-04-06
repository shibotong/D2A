//
//  HeroData.swift
//  D2A
//
//  Created by Shibo Tong on 1/4/2026.
//

protocol HeroProtocol: Identifiable {
    var heroID: Int { get }
    var localizedName: String { get }
    var primaryAttribute: String { get }
    var hero: Hero { get }
    var abilityData: [AbilityData] { get }
}

extension HeroProtocol {
    var id: Int {
        return heroID
    }
}

struct HeroData: HeroProtocol {
    let hero: Hero
    let localization: HeroTranslation
    let abilities: [AbilityData]
    
    var heroID: Int {
        return Int(localization.heroID)
    }
    
    var localizedName: String {
        return localization.displayName ?? ""
    }
    
    var primaryAttribute: String {
        return hero.primaryAttr ?? ""
    }
    
    var heroAbilities: [String] {
        hero.abilities ?? []
    }
    
    var abilityData: [AbilityData] {
        abilities
    }
}

protocol AbilityProtocol: Identifiable {
    var id: Int { get }
    var name: String { get }
    
    
    var manaCost: String? { get }
    var coolDown: String? { get }
    var behavior: String? { get }
    var damageType: String? { get }
    var targetTeam: String? { get }
    var targetType: String? { get }
    var dispellable: String? { get }
    var bkbPierce: String? { get }
    
    // Localized fields
    var displayName: String { get }
    var lore: String? { get }
    var description: String? { get }
    var scepter: String? { get }
    var shard: String? { get }
    var attributes: [AbilityTranslation.Attribute]? { get }
}

struct AbilityData: AbilityProtocol {
    
    let ability: Ability
    let localization: AbilityTranslation

    var id: Int {
        Int(ability.abilityID)
    }

    var name: String {
        ability.name ?? ""
    }

    var description: String? {
        localization.desc
    }

    var displayName: String {
        localization.displayName ?? ""
    }

    var lore: String? {
        localization.lore
    }

    var manaCost: String? {
        ability.manaCost
    }

    var coolDown: String? {
        ability.coolDown
    }

    var behavior: String? {
        ability.behavior
    }

    var damageType: String? {
        ability.damageType
    }

    var targetTeam: String? {
        ability.targetTeam
    }

    var targetType: String? {
        ability.targetType
    }

    var dispellable: String? {
        ability.dispellable
    }

    var bkbPierce: String? {
        ability.bkbPierce
    }
    
    var scepter: String? {
        localization.aghanimDescription
    }
    
    var shard: String? {
        localization.shardDescription
    }

    var attributes: [AbilityTranslation.Attribute]? {
        return localization.localizedAttributes
    }
}
