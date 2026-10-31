//
//  AbilityRecipe.swift
//  D2A
//
//  Created by Shibo Tong on 20/4/2026.
//

import OpenDota

struct AbilityRecipe: AbilityDTO {
    let abilityID: Int
    let name: String
    let data: ODAbility

    // MARK: AbilityDTO
    var behavior: [String]? {
        data.behavior
    }

    var bkbpierce: [String]? {
        data.bkbpierce
    }

    var dmgType: [String]? {
        data.dmgType
    }

    var desc: String? {
        data.desc
    }

    var dispellable: String? {
        data.dispellable
    }

    var cd: [String]? {
        data.cd
    }

    var mc: [String]? {
        data.mc
    }

    var targetTeam: [String]? {
        data.targetTeam
    }

    var targetType: [String]? {
        data.targetType
    }

    var dname: String? {
        data.dname
    }

    var lore: String? {
        data.lore
    }

    var img: String? {
        data.img
    }
}
