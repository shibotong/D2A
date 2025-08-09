//
//  OpenDotaConstantProcessor.swift
//  D2A
//
//  Created by Shibo Tong on 23/7/2025.
//

class OpenDotaConstantProcessor {
    
    static let shared = OpenDotaConstantProcessor()
    
    func processHeroes(heroes: [String: ODHero], abilities: [String: ODHeroAbilities], lores: [String: String]) -> [ODHero] {
        var heroesArray: [ODHero] = []
        for (_, hero) in heroes {
            if let ability = abilities[hero.name] {
                hero.abilities = ability.abilities
                let talents = ability.talents.map { Talent(ability: $0.name, slot: $0.level) }
                hero.talents = talents
                let lore = lores[hero.heroNameLowerCase] ?? ""
                let translation = HeroTranslation(language: .english, displayName: hero.localizedName, lore: lore)
                hero.translation = translation
            }
            heroesArray.append(hero)
        }
        return heroesArray
    }
    
    func processGameModes(modes: [String: ODGameMode]) -> [ODGameMode] {
        var gameModes: [ODGameMode] = []
        for (_, mode) in modes {
            gameModes.append(mode)
        }
        return gameModes
    }
    
    func processAbilities(ability: [String: ODAbility], ids: [String: String], scepters: [ODScepter]) -> [ODAbility] {
        var scepterDict: [String: String] = [:]
        var shardDict: [String: String] = [:]
        
        for scepter in scepters {
            scepterDict[scepter.scepterSkillName] = scepter.scepterDesc
            shardDict[scepter.shardSkillName] = scepter.shardDesc
        }
        
        var abilities: [ODAbility] = []
        
        for (abilityIDString, name) in ids {
            guard var ability = ability[name] else {
                logInfo("\(name) cannot be found", category: .opendotaConstant)
                continue
            }
            guard let abilityID = Int(abilityIDString) else {
                logWarn("\(abilityIDString) abilityID is not a number", category: .opendotaConstant)
                continue
            }
            guard let dname = ability.dname, !dname.isEmpty else {
                logInfo("\(name) has empty dname", category: .opendotaConstant)
                continue
            }
            ability.id = abilityID
            ability.name = name
            if let displayName = ability.dname {
                if let scepterDesc = scepterDict[displayName] {
                    ability.scepter = scepterDesc
                }
                if let shardDesc = shardDict[displayName] {
                    ability.shard = shardDesc
                }
            }
            
            abilities.append(ability)
        }
        return abilities
    }
}
