//
//  OpenDotaConstantProcessor.swift
//  D2A
//
//  Created by Shibo Tong on 23/7/2025.
//

class OpenDotaConstantProcessor {
    
    static let shared = OpenDotaConstantProcessor()
    
    func processHeroes(heroes: [String: ODHero]) -> [ODHero] {
        var heroesArray: [ODHero] = []
        for (_, value) in heroes {
            heroesArray.append(value)
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
}
