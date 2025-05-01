//
//  StratzController.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

import StratzAPI
import Combine

class StratzController {
    
    func loadAbilities() async -> [StratzAbility] {
        do {
            return try loadStratzAbilities()
        } catch {
            D2ALogger
        }
    }
    
    private func loadStratzAbilities() async throws -> [StratzAbility] {
        try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: AbilityQuery(language: .init(languageCode))) { result in
                switch result {
                case .success(let graphQLResult):
                    if let abilitiesConnection = graphQLResult.data?.constants?.abilities {
                        let abilities = abilitiesConnection.compactMap({ StratzAbility(ability: $0) })
                        continuation.resume(returning: abilities)
                    }
                    
                    if let errors = graphQLResult.errors {
                        let message = errors
                            .map { $0.localizedDescription }
                            .joined(separator: "\n")
                        continuation.resume(throwing: D2AError(message: message))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
