//
//  AbilityLocalisation.swift
//  D2A
//
//  Created by Shibo Tong on 10/9/2024.
//

import Foundation
import StratzAPI

final public class AbilityLocalisation: NSObject, NSSecureCoding {
    
    typealias Localisation = LocaliseQuery.Data.Constants.Ability.Language
    
    public static var supportsSecureCoding: Bool = true
    
    var language: String
    var displayName: String
    var lore: String?
    var abilityDescription: String?
    var scepter: String?
    var shard: String?
    
    enum Key: String {
        case language, displayName, lore, ability, scepter, shard
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(language, forKey: Key.language.rawValue)
        coder.encode(displayName, forKey: Key.displayName.rawValue)
        coder.encode(lore, forKey: Key.lore.rawValue)
        coder.encode(abilityDescription, forKey: Key.ability.rawValue)
        coder.encode(scepter, forKey: Key.scepter.rawValue)
        coder.encode(shard, forKey: Key.shard.rawValue)
    }
    
    convenience required public init?(coder: NSCoder) {
        guard let language = coder.decodeObject(forKey: Key.language.rawValue) as? String,
              let displayName = coder.decodeObject(forKey: Key.displayName.rawValue) as? String else {
            return nil
        }
        let lore = coder.decodeObject(forKey: Key.lore.rawValue) as? String
        let description = coder.decodeObject(forKey: Key.ability.rawValue) as? String
        let scepter = coder.decodeObject(forKey: Key.scepter.rawValue) as? String
        let shard = coder.decodeObject(forKey: Key.shard.rawValue) as? String
        
        self.init(language: language,
                  displayName: displayName,
                  lore: lore,
                  description: description,
                  scepter: scepter,
                  shard: shard)
    }
    
    init(language: String, displayName: String, lore: String? = nil, description: String? = nil, scepter: String? = nil, shard: String? = nil) {
        self.language = language
        self.displayName = displayName
        self.lore = lore
        self.abilityDescription = description
        self.scepter = scepter
        self.shard = shard
    }
    
    convenience init?(localisation: Localisation, language: String, type: AbilityType) {
        guard let displayName = localisation.displayName else {
            return nil
        }
        var description: String? = nil
        var shard: String? = nil
        var scepter: String? = nil
        
        switch type {
        case .scepter:
            scepter = localisation.aghanimDescription
        case .shared:
            shard = localisation.shardDescription
        case .none:
            scepter = localisation.aghanimDescription
            shard = localisation.shardDescription
            description = localisation.description?.compactMap { $0 }.joined(separator: "\n")
        }
        
        self.init(language: language,
                  displayName: displayName,
                  lore: localisation.lore,
                  description: description,
                  scepter: scepter,
                  shard: shard)
    }
}

@objc(AbilityLocalisationTransformer)
final class AbilityLocalisationTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: AbilityLocalisationTransformer.self))
    
    override static var allowedTopLevelClasses: [AnyClass] {
        return [AbilityLocalisation.self]
    }
    
    static func register() {
        let transformer = AbilityLocalisationTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
