//
//  StratzController.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

import Combine
import StratzAPI

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
      Network.shared.apollo.fetch(query: AbilityQuery(language: .init(languageCode))) {
        result in
        switch result {
        case .success(let graphQLResult):
          guard let abilitiesConnection = graphQLResult.data?.constants?.abilities else {
            guard let errors = graphQLResult.errors else {
              logWarn(
                "0 abilities loaded from Stratz and no error thrown",
                category: .stratz)
              continuation.resume(returning: [])
              return
            }
            let message =
              errors
              .map { $0.localizedDescription }
              .joined(separator: "\n")
            continuation.resume(throwing: D2AError(message: message))
            return
          }

          let abilities = abilitiesConnection.compactMap({ StratzAbility(ability: $0) })
          logDebug("\(abilities.count) abilities loaded from Stratz", category: .stratz)
          continuation.resume(returning: abilities)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
