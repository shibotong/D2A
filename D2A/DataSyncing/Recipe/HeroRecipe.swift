//
//  HeroRecipe.swift
//  D2A
//
//  Created by Shibo Tong on 4/4/2026.
//

import Stratz
import OpenDota

struct HeroRecipe {
    let heroID: Int
    let data: ODHero
    let abilities: ODHeroAbility
    let additionalData: SKHeroAdditional
}
