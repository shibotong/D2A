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
}
