//
//  DataHelper.swift
//  App
//
//  Created by Shibo Tong on 6/6/2022.
//

import Foundation
import SwiftUI

struct DataHelper {
    
    private static let unranked = NSLocalizedString("Unranked", comment: "Unrank ranking")
    private static let immortal = NSLocalizedString("Immortal", comment: "Immortal ranking")
    private static let divine = NSLocalizedString("Divine %@", comment: "Divine ranking")
    private static let ancient = NSLocalizedString("Ancient %@", comment: "Ancient ranking")
    private static let legend = NSLocalizedString("Legend %@", comment: "Legend ranking")
    private static let archon = NSLocalizedString("Archon %@", comment: "Archon ranking")
    private static let crusader = NSLocalizedString("Crusader %@", comment: "Crusader ranking")
    private static let guardian = NSLocalizedString("Guardian %@", comment: "Guardian ranking")
    private static let herald = NSLocalizedString("Herald %@", comment: "Herald ranking")
    
    static func transferRank(rank: Int?) -> String {
        guard let rank = rank else {
            return Self.unranked
        }
        let number = rank % 10
        var numberRoman = ""
        switch number {
        case 1: numberRoman = "I"
        case 2: numberRoman = "II"
        case 3: numberRoman = "III"
        case 4: numberRoman = "IV"
        case 5: numberRoman = "V"
        default: numberRoman = ""
        }

        if rank >= 80 {
            return Self.immortal
        } else if rank > 70 {
            return String(format: Self.divine, numberRoman)
        } else if rank > 60 {
            return String(format: Self.ancient, numberRoman)
        } else if rank > 50 {
            return String(format: Self.legend, numberRoman)
        } else if rank > 40 {
            return String(format: Self.archon, numberRoman)
        } else if rank > 30 {
            return String(format: Self.crusader, numberRoman)
        } else if rank > 20 {
            return String(format: Self.guardian, numberRoman)
        } else if rank > 10 {
            return String(format: Self.herald, numberRoman)
        } else {
            return Self.unranked
        }
    }
}
