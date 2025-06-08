//
//  DataHelper.swift
//  App
//
//  Created by Shibo Tong on 6/6/2022.
//

import Foundation
import SwiftUI

struct DataHelper {
    static func transferRank(rank: Int?) -> LocalizedStringKey {
        if let rank = rank {
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
                return LocalizedStringKey("Immortal")
            } else if rank > 70 {
                return LocalizedStringKey("Divine \(numberRoman)")
            } else if rank > 60 {
                return LocalizedStringKey("Ancient \(numberRoman)")
            } else if rank > 50 {
                return LocalizedStringKey("Legend \(numberRoman)")
            } else if rank > 40 {
                return LocalizedStringKey("Archon \(numberRoman)")
            } else if rank > 30 {
                return LocalizedStringKey("Crusader \(numberRoman)")
            } else if rank > 20 {
                return LocalizedStringKey("Guardian \(numberRoman)")
            } else if rank > 10 {
                return LocalizedStringKey("Herald \(numberRoman)")
            } else {
                return LocalizedStringKey("Unranked")
            }
        } else {
            return LocalizedStringKey("Unranked")
        }
    }
}
