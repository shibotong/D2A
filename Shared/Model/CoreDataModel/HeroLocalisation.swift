//
//  HeroLocalisation.swift
//  D2A
//
//  Created by Shibo Tong on 20/9/2024.
//

import Foundation
import StratzAPI

final public class HeroLocalisation: NSObject, NSSecureCoding {
    
    typealias Localisation = LocaliseQuery.Data.Constants.Hero.Language
    
    public static var supportsSecureCoding: Bool = true
    
    var language: String
    var displayName: String
    var lore: String?
    var hype: String?
    
    enum Key: String {
        case language, displayName, lore, hype
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(language, forKey: Key.language.rawValue)
        coder.encode(displayName, forKey: Key.displayName.rawValue)
        coder.encode(lore, forKey: Key.lore.rawValue)
        coder.encode(hype, forKey: Key.hype.rawValue)
    }
    
    convenience required public init?(coder: NSCoder) {
        guard let language = coder.decodeObject(forKey: Key.language.rawValue) as? String,
              let displayName = coder.decodeObject(forKey: Key.displayName.rawValue) as? String else {
            return nil
        }
        let lore = coder.decodeObject(forKey: Key.lore.rawValue) as? String
        let hype = coder.decodeObject(forKey: Key.hype.rawValue) as? String
        
        self.init(language: language,
                  displayName: displayName,
                  lore: lore,
                  hype: hype)
    }
    
    init(language: String, displayName: String, lore: String? = nil, hype: String? = nil) {
        self.language = language
        self.displayName = displayName
        self.lore = lore
        self.hype = hype
    }
    
    convenience init?(localisation: Localisation, language: String) {
        guard let displayName = localisation.displayName else {
            return nil
        }
        
        self.init(language: language,
                  displayName: displayName,
                  lore: localisation.lore,
                  hype: localisation.hype)
    }
}

@objc(HeroLocalisationTransformer)
final class HeroLocalisationTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: HeroLocalisationTransformer.self))
    
    override static var allowedTopLevelClasses: [AnyClass] {
        return [HeroLocalisation.self, NSArray.self]
    }
    
    static func register() {
        let transformer = HeroLocalisationTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
