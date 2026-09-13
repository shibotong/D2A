//
//  Region.swift
//  D2A
//
//  Created by Shibo Tong on 13/9/2026.
//

import Foundation

struct Region {
    private let regionID: Int
    
    init(regionID: Int) {
        self.regionID = regionID
    }
    
    var name: String {
        switch regionID {
        case 1:
            return String(localized: .regionUswest)
        case 2:
            return String(localized: .regionUseast)
        case 3:
            return String(localized: .regionEurope)
        case 5:
            return String(localized: .regionSingapore)
        case 6:
            return String(localized: .regionDubai)
        case 7:
            return String(localized: .regionAustralia)
        case 8:
            return String(localized: .regionStockholm)
        case 9:
            return String(localized: .regionAustria)
        case 10:
            return String(localized: .regionBrazil)
        case 11:
            return String(localized: .regionSouthafrica)
        case 12:
            return String(localized: .regionPwTelecomShanghai)
        case 13:
            return String(localized: .regionPwUnicom)
        case 14:
            return String(localized: .regionChile)
        case 15:
            return String(localized: .regionPeru)
        case 16:
            return String(localized: .regionIndia)
        case 17:
            return String(localized: .regionPwTelecomGuangdong)
        case 18:
            return String(localized: .regionPwTelecomZhejiang)
        case 19:
            return String(localized: .regionJapan)
        case 20:
            return String(localized: .regionPwTelecomWuhan)
        case 25:
            return String(localized: .regionPwUnicomTianjin)
        case 37:
            return String(localized: .regionTaiwan)
        case 38:
            return String(localized: .regionArgentina)
        default:
            return String(localized: .regionUnknown(regionID))
        }
    }
}
