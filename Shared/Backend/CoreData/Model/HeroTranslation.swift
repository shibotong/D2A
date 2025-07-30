//
//  HeroTranslation.swift
//  D2A
//
//  Created by Shibo Tong on 30/7/2025.
//

import Foundation

@objcMembers
public class HeroTranslation: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    public var language: String
    public var displayName: String
    public var lore: String
    
    enum CodingKeys: String, CodingKey {
        case language
        case displayName
        case lore
    }
    
    init(language: String, displayName: String, lore: String) {
        self.language = language
        self.displayName = displayName
        self.lore = lore
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(language, forKey: CodingKeys.language.rawValue)
        coder.encode(displayName, forKey: CodingKeys.displayName.rawValue)
        coder.encode(lore, forKey: CodingKeys.lore.rawValue)
    }
    
    required public convenience init?(coder: NSCoder) {
        guard let language = coder.decodeObject(forKey: CodingKeys.language.rawValue) as? String,
              let displayName = coder.decodeObject(forKey: CodingKeys.displayName.rawValue) as? String,
              let lore = coder.decodeObject(forKey: CodingKeys.lore.rawValue) as? String else {
            logError("Failed to decode HeroTranslation", category: .coredata)
            return nil
        }
        self.init(language: language, displayName: displayName, lore: lore)
    }
}
