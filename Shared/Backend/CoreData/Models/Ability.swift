//
//  Ability.swift
//  D2A
//
//  Created by Shibo Tong on 6/4/2026.
//

import Foundation

extension Ability {
    
    var imageURL: URL? {
        guard let name else {
            return nil
        }
        return URL(string: "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/abilities/\(name).png")
    }
    
}
