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
            return String(localized: .Region.uswest)
        case 2:
            return String(localized: .Region.useast)
        case 3:
            return String(localized: .Region.europe)
        case 5:
            return String(localized: .Region.singapore)
        case 6:
            return String(localized: .Region.dubai)
        case 7:
            return String(localized: .Region.australia)
        case 8:
            return String(localized: .Region.stockholm)
        case 9:
            return String(localized: .Region.austria)
        case 10:
            return String(localized: .Region.brazil)
        case 11:
            return String(localized: .Region.southafrica)
        case 12:
            return String(localized: .Region.pwTelecomShanghai)
        case 13:
            return String(localized: .Region.pwUnicom)
        case 14:
            return String(localized: .Region.chile)
        case 15:
            return String(localized: .Region.peru)
        case 16:
            return String(localized: .Region.india)
        case 17:
            return String(localized: .Region.pwTelecomGuangdong)
        case 18:
            return String(localized: .Region.pwTelecomZhejiang)
        case 19:
            return String(localized: .Region.japan)
        case 20:
            return String(localized: .Region.pwTelecomWuhan)
        case 25:
            return String(localized: .Region.pwUnicomTianjin)
        case 37:
            return String(localized: .Region.taiwan)
        case 38:
            return String(localized: .Region.argentina)
        default:
            return String(localized: .Region.unknown)
        }
    }
}
