//
//  StratzController.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

import StratzAPI
import Combine

protocol StratzProviding {
    func loadAbilities() async -> [StratzAbility]
}

class StratzController: StratzProviding {
    
    static let shared = StratzController()
    
    func loadAbilities() async -> [StratzAbility] {
        do {
            return try await loadStratzAbilities()
        } catch {
            logError(error.localizedDescription, category: .stratz)
            return []
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
