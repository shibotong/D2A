//
//  MockOpenDotaFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 19/4/2026.
//

@testable import D2A
import Foundation

struct MockOpenDotaFetcher: OpenDotaFetching {
    func constants(service: D2A.OpenDotaConstantService) async throws -> Any {
        switch service {
        case .abilities:
            return try JSONSerialization.jsonObject(with: PreviewConstantData.abilities)
        case .abilityIDs:
            return PreviewConstantData.abilityIDs
        case .heroes:
            return try JSONSerialization.jsonObject(with: PreviewConstantData.heroes)
        case .heroAbilities:
            return try JSONSerialization.jsonObject(with: PreviewConstantData.heroAbilities)
        default:
            return "service not provided"
        }
    }
}
