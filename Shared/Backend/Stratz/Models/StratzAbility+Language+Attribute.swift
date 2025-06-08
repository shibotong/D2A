//
//  StratzLanguage.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

import Foundation

extension StratzAbility {
  struct Language {
    var displayName: String
    var description: [String]
    var attributes: [String]
    var lore: String?
    var aghanimDescription: String?
    var shardDescription: String?
    var notes: [String]
  }

  struct Attribute {
    var name: String
    var value: String
  }

  var localizedAttributes: [StratzAttribute]? {
    guard let localizedString = language?.attributes.compactMap({ $0 }) else {
      return nil
    }
    var localizedAttributes: [StratzAttribute] = []
    for item in localizedString {
      let splits = item.split(separator: colonLocalize)
      if splits.count == 2 {
        let header = String(splits.first ?? "")
        var message = String(splits.last ?? "")
        if message.first == "%" && message.last == "%" {
          let key = extractAttributeKey(input: message, abilityName: name)
          message =
            attributes.filter({ attribute in
              return attribute.name == key
            }).first?.value ?? message
        }
        localizedAttributes.append(StratzAttribute(name: header, description: message))
      } else {
        localizedAttributes.append(StratzAttribute(name: item, description: ""))
      }
    }
    return localizedAttributes
  }

  func extractAttributeKey(input: String, abilityName: String) -> String {
    let pattern = "%DOTA_Tooltip_Ability_\(abilityName)_(\\w+)%"
    do {
      // Create a regular expression object with the defined pattern
      let regex = try NSRegularExpression(pattern: pattern, options: [])

      // Find the first match in the input string
      if let match = regex.firstMatch(
        in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
      {
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

struct StratzAttribute: Identifiable, Hashable {
  public let name: String
  public let description: String

  public var id: String {
    return name
  }
}
