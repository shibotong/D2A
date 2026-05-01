//
//  MockOpenDotaFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 19/4/2026.
//

import OpenDota

struct MockOpenDotaFetcher: OpenDotaFetching {
    func constants(service: OpenDotaFetcher.ConstantService) async throws -> Any {
        switch service {
        case .abilities:
            return PreviewConstantData.abilities
        case .abilityIDs:
            return PreviewConstantData.abilityIDs
        case .heroes:
            return PreviewConstantData.heroes
        case .heroAbilities:
            return PreviewConstantData.heroAbilities
        default:
            return "service not provided"
        }
    }
}
