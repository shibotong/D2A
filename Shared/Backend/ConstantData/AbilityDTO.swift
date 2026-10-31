//
//  AbilityDTO.swift
//  D2A
//
//  Created by Shibo Tong on 31/10/2026.
//

protocol AbilityDTO: Sendable {
    var abilityID: Int { get }
    var name: String { get }
    var behavior: [String]? { get }
    var bkbpierce: [String]? { get }
    var dmgType: [String]? { get }
    var desc: String? { get }
    var dispellable: String? { get }
    var cd: [String]? { get }
    var mc: [String]? { get }
    var targetTeam: [String]? { get }
    var targetType: [String]? { get }
    var dname: String? { get }
    var lore: String? { get }
    var img: String? { get }
}
