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
    var heroAbilities: [Ability] { get }
}

extension HeroProtocol {
    var id: Int {
        return heroID
    }
}
