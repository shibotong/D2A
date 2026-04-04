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
    var heroAbilities: [String] { get }
    var hero: Hero { get }
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
}

protocol AbilityProtocol: Identifiable {
    
}

struct AbilityData: AbilityProtocol {
    
    var id: Int {
        Int(ability.abilityID)
    }
    
    let ability: Ability
    let localization: AbilityTranslation
}
