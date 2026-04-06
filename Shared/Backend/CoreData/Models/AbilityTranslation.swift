//
//  AbilityTranslation.swift
//  D2A
//
//  Created by Shibo Tong on 25/3/2026.
//

import CoreData

extension AbilityTranslation {
    
    struct Attribute: Hashable {
        let name: String
        let description: String
    }
    
    var localizedAttributes: [Attribute]? {
        guard let localizedString = attributes else {
            return nil
        }
        var localizedAttributes: [Attribute] = []
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
                        return attribute == key
                    }).first ?? message
                }
                localizedAttributes.append(Attribute(name: header, description: message))
            } else {
                localizedAttributes.append(Attribute(name: item, description: ""))
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
