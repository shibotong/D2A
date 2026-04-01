//
//  HeroData.swift
//  D2A
//
//  Created by Shibo Tong on 1/4/2026.
//

protocol HeroProtocol: Identifiable {
    var heroID: Int { get }
    var displayName: String { get }
    var primaryAttr: String { get }
}

extension HeroProtocol {
    var id: Int {
        return heroID
    }
}

struct HeroData: HeroProtocol {
    let hero: Hero
    let localization: HeroTranslation
    
    var heroID: Int {
        return Int(localization.heroID)
    }
    
    var displayName: String {
        return localization.displayName ?? ""
    }
    
    var primaryAttr: String {
        return hero.primaryAttr ?? ""
    }
}
