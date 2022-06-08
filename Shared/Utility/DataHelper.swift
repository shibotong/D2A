//
//  DataHelper.swift
//  App
//
//  Created by Shibo Tong on 6/6/2022.
//

import Foundation

struct DataHelper {
    static func transferRank(rank: Int?) -> String {
        if let rank = rank {
            var level = ""
            if rank >= 80 {
                return "Immortal"
            } else if rank > 70 {
                level = "Divine"
            } else if rank > 60 {
                level = "Ancient"
            } else if rank > 50 {
                level = "Legend"
            } else if rank > 40 {
                level = "Archon"
            } else if rank > 30 {
                level = "Crusader"
            } else if rank > 20 {
                level = "Guardian"
            } else if rank > 10 {
                level = "Herald"
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
            return "\(level) \(numberRoman)"
            
        } else {
            return "Unranked"
        }
    }
}
