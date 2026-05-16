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
        return fetchLocalization()
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
    
    var localizedDescription: String? {
        return localization?.desc
    }
    
    var localizedLore: String? {
        return localization?.lore
    }
    
    func fetchLocalization(language: DataLanguageEnum = AppConfig.shared.languageCode) -> AbilityTranslation? {
        guard let abilityLocalizations = localizations?.allObjects as? [AbilityTranslation] else {
            return nil
        }
        return abilityLocalizations.first(where: { $0.language == language.rawValue })
    }
}
