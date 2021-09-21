//
//  Hero.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 5/7/21.
//

import Foundation
import UIKit

class Hero: Identifiable, Decodable {
    var id: Int
    var name: String
    var localizedName: String
    var primaryAttr: String
    var attackType: String
    var roles: [String]
    var legs: Int
    var img: String
    var icon: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case attackType = "attack_type"
        case roles
        case legs
        case img
        case icon
    }
    
}

