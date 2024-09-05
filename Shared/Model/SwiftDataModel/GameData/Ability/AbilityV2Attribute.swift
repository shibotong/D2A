//
//  AbilityV2Attribute.swift
//  D2A
//
//  Created by Shibo Tong on 1/9/2024.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
class AbilityV2Attribute {
    var key: String
    var header: String
    var value: String
    var generated: Bool?
    
    var ability: AbilityV2?
    
    init(key: String, header: String, value: String, generated: Bool? = nil) {
        self.key = key
        self.header = header
        self.value = value
        self.generated = generated
    }
    
    convenience init(attribute: AbilityAttribute) {
        self.init(key: attribute.key ?? "", header: attribute.header ?? "", value: attribute.value?.transformString() ?? "", generated: attribute.generated)
    }
}
