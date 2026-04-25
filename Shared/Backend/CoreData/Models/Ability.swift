//
//  Ability.swift
//  D2A
//
//  Created by Shibo Tong on 23/4/2026.
//

extension Ability {
    var displayName: String {
        return localization?.displayName ?? dname ?? ""
    }
    
    var localization: AbilityTranslation? {
        let language = AppConfig.shared.languageCode
        guard let abilityLocalizations = localizations?.allObjects as? [AbilityTranslation] else {
            return nil
        }
        return abilityLocalizations.first(where: { $0.language == language.rawValue })
    }
    
    var scepter: String? {
        return localization?.aghanimDescription
    }
    
    var shard: String? {
        return localization?.shardDescription
    }
    
    var localizedAttributes: [AbilityTranslation.Attribute] {
        return localization?.localizedAttributes ?? []
    }
}
