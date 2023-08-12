//
//  File.swift
//  
//
//  Created by Shibo Tong on 25/7/2023.
//

import Foundation

let currentLanguage: String = Locale.current.languageCode ?? "en"
fileprivate let colonLocalize: Character = {
    switch currentLanguage {
    case "en":
        return ":"
    case "zh":
        return "："
    default:
        return ":"
    }
}()

extension AbilityQuery.Data.Constants.Ability {
    public var localizedAttributes: [StratzAttribute]? {
        guard let localizedString = language?.attributes?.compactMap({ $0 }) else {
            return nil
        }
        var localizedAttributes: [StratzAttribute] = []
        for item in localizedString {
            let splits = item.split(separator: colonLocalize)
            if splits.count == 2 {
                let header = String(splits.first ?? "")
                var message = String(splits.last ?? "")
                if let abilityName = name,
                   let attributes,
                   message.first == "%" && message.last == "%" {
                    let key = extractAttributeKey(input: message, abilityName: abilityName)
                    message = attributes.filter({ attribute in
                        return attribute?.name == key
                    }).first??.value ?? message
                }
                localizedAttributes.append(StratzAttribute(name: header, description: message))
            } else {
                localizedAttributes.append(StratzAttribute(name: item, description: ""))
            }
        }
        return localizedAttributes
    }
    
    private func extractAttributeKey(input: String, abilityName: String) -> String {
        let pattern = "%DOTA_Tooltip_Ability_\(abilityName)_(\\w+)%"
        do {
            // Create a regular expression object with the defined pattern
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            // Find the first match in the input string
            if let match = regex.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
                // Extract the substring using the captured group
                let range = Range(match.range(at: 1), in: input)!
                return String(input[range])
            }
            return input
        } catch {
            print("Error creating regular expression: \(error)")
            return input
        }
    }
}

public struct StratzAttribute: Identifiable, Hashable {
    public let name: String
    public let description: String
    
    public var id: String {
        return name
    }
}
