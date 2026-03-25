//
//  StratzFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

import Apollo
import StratzAPI

protocol StratzFetching {
    func heroes() async throws -> [SKHero]
    func abilities(language: DataLanguageEnum) async throws -> [SKAbility]
}

extension StratzFetching {
    func abilities() async throws -> [SKAbility] {
        return try await abilities(language: AppConfig.languageCode)
    }
}

struct StratzFetcher: StratzFetching {
    
    static let shared = StratzFetcher()

    private let apollo: ApolloClient

    init(apollo: ApolloClient = Network.shared.apollo) {
        self.apollo = apollo
    }

    func heroes() async throws -> [SKHero] {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[SKHero], Error>) in
            apollo.fetch(query: HeroesQuery(language: .init(languageCode))) { result in
                switch result {
                case .success(let graphQLResult):
                    guard let stratzHeroes = graphQLResult.data?.constants?.heroes else {
                        continuation.resume(throwing: APIError.networkError)
                        return
                    }
                    let heroes: [SKHero] = stratzHeroes.compactMap { hero in
                        guard let hero, let stratzLanguage = hero.language, let heroID = hero.id else {
                            return nil
                        }
                        let roles: [SKHero.Role]
                        if let stratzRoles = hero.roles {
                            roles = stratzRoles.compactMap { role in
                                guard let level = role?.level, let roleId = role?.roleId else {
                                    return nil
                                }
                                return SKHero.Role(level: Int(level), roleId: roleId.rawValue)
                            }
                        } else {
                            roles = []
                        }

                        return SKHero(id: Int(heroID), roles: roles, displayName: stratzLanguage.displayName ?? "", lore: stratzLanguage.lore ?? "", hype: stratzLanguage.hype ?? "")
                    }
                    continuation.resume(returning: heroes)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func abilities(language: DataLanguageEnum) async throws -> [SKAbility] {
        return try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: AbilityQuery(language: .init(language.language))) { result in
                switch result {
                case .success(let graphQLResult):
                    guard let stratzAbilities = graphQLResult.data?.constants?.abilities else {
                        continuation.resume(throwing: APIError.networkError)
                        return
                    }
                    let abilities: [SKAbility] = stratzAbilities.compactMap { ability in
                        guard let ability, let stratzLanguage = ability.language else {
                            return nil
                        }
                        return SKAbility(
                            id: Int(ability.id ?? 0),
                            displayName: stratzLanguage.displayName,
                            lore: stratzLanguage.lore,
                            description: stratzLanguage.description?.compactMap { $0 } ?? [],
                            attributes: stratzLanguage.attributes?.compactMap { $0 },
                            aghanimDescription: stratzLanguage.aghanimDescription,
                            shardDescription: stratzLanguage.shardDescription
                        )
                    }
                    continuation.resume(returning: abilities)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
