//
//  AbilityAttribute.swift
//  D2A
//
//  Created by Shibo Tong on 7/9/2024.
//

import Foundation

extension AbilityAttribute {
    func update(_ attribute: AbilityCodableAttribute) {
        key = attribute.key
        header = attribute.header
        value = attribute.value?.transformString()
        generated = attribute.generated ?? false
    }
}
