//
//  Ability.swift
//  App
//
//  Created by Shibo Tong on 12/9/21.
//

import Foundation

struct Ability: Codable {
    var img: String?
    var dname: String?
    enum CodingKeys: String, CodingKey {
        case img = "img"
        case dname
    }
}
