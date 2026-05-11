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
    var heroName: String { get }
    var hero: Hero { get }
    var heroAbilities: [Ability] { get }
    var talent1LeftName: String { get }
    var talent2LeftName: String { get }
    var talent3LeftName: String { get }
    var talent4LeftName: String { get }
    var talent1RightName: String { get }
    var talent2RightName: String { get }
    var talent3RightName: String { get }
    var talent4RightName: String { get }
}

extension HeroProtocol {
    var id: Int {
        return heroID
    }
}
