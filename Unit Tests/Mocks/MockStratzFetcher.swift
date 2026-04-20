//
//  MockStratzFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 19/4/2026.
//

@testable import D2A

struct MockStratzFetcher: StratzFetching {
    func heroes(language: DataLanguageEnum) async throws -> [SKHero] {
        return PreviewConstantData.heroTranslation
    }
    
    func heroAdditionalData() async throws -> [SKHeroAdditional] {
        return PreviewConstantData.heroAdditionalData
    }
    
    func abilities(language: DataLanguageEnum) async throws -> [SKAbility] {
        return PreviewConstantData.abilityTranslation
    }
}
