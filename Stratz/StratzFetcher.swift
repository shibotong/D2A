//
//  StratzFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

internal import Apollo
internal import StratzAPI
import Foundation

public enum StratzLanguage {
    case schinese
    case english
    
    var language: LanguageEnum {
        switch self {
        case .schinese:
            return .sChinese
        case .english:
            return .english
        }
    }
}

public protocol StratzFetching {
    func heroes(language: StratzLanguage) async throws -> [SKHero]
    func heroAdditionalData() async throws -> [SKHeroAdditional]
    func abilities(language: StratzLanguage) async throws -> [SKAbility]
}

public struct StratzFetcher: StratzFetching {
    
    public static let shared = StratzFetcher()

    private let apollo: ApolloClient = StratzNetwork.shared.apollo

    public init() { }

    public func heroes(language: StratzLanguage) async throws -> [SKHero] {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[SKHero], Error>) in
            apollo.fetch(query: HeroesQuery(language: .init(language.language))) { result in
                switch result {
                case .success(let graphQLResult):
                    guard let stratzHeroes = graphQLResult.data?.constants?.heroes else {
                        continuation.resume(throwing: StratzError.networkError)
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
    
    public func heroAdditionalData() async throws -> [SKHeroAdditional] {
        return try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: HeroDataQuery()) { result in
                switch result {
                case .success(let graphQLResult):
                    guard let data = graphQLResult.data?.constants?.heroes else {
                        continuation.resume(throwing: StratzError.networkError)
                        return
                    }
                    let additionalData: [SKHeroAdditional] = data.compactMap { hero in
                        guard let heroID = hero?.id, let complexity = hero?.stats?.complexity, let roles = hero?.roles, let name = hero?.name else {
                            return nil
                        }
                        let skRoles: [SKHeroAdditional.Role] = roles.compactMap { role in
                            guard let roleID = role?.roleId, let level = role?.level else {
                                return nil
                            }
                            return .init(level: Int(level), roleId: roleID.rawValue)
                        }
                        
                        return SKHeroAdditional(heroID: Int(heroID), name: name, complexity: Int(complexity), roles: skRoles)
                    }
                    continuation.resume(returning: additionalData)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func abilities(language: StratzLanguage) async throws -> [SKAbility] {
        return try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: AbilityQuery(language: .init(language.language))) { result in
                switch result {
                case .success(let graphQLResult):
                    guard let stratzAbilities = graphQLResult.data?.constants?.abilities else {
                        continuation.resume(throwing: StratzError.networkError)
                        return
                    }
                    let abilities: [SKAbility] = stratzAbilities.compactMap { ability in
                        guard let ability, let stratzLanguage = ability.language, let id = ability.id, let name = ability.name else {
                            return nil
                        }
                        return SKAbility(
                            id: Int(id),
                            name: name,
                            displayName: stratzLanguage.displayName,
                            lore: stratzLanguage.lore,
                            description: stratzLanguage.description?.compactMap { $0?.replacingOccurrences(of: "<br>", with: "\n") } ?? [],
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
