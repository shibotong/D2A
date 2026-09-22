//
//  Region.swift
//  D2A
//
//  Created by Shibo Tong on 13/9/2026.
//

import Foundation

enum Region: String {
    case USWEST
    case USEAST
    case EUROPE
    case SINGAPORE
    case DUBAI
    case AUSTRALIA
    case STOCKHOLM
    case AUSTRIA
    case BRAZIL
    case SOUTHAFRICA
    case PW_TEL_SHANGHAI
    case PW_UNICOM
    case CHILE
    case PERU
    case INDIA
    case PW_TEL_GUANGDONG
    case PW_TEL_ZHEJIANG
    case JAPAN
    case PW_TEL_WUHAN
    case PW_TEL_TIANJIN
    case TAIWAN
    case ARGENTINA
    case UNKNOWN(Int)
    
    static func from(regionId: Int) -> Region {
        switch regionId {
        case 1:
            return .USWEST
        case 2:
            return .USEAST
        case 3:
            return .EUROPE
        case 5:
            return .SINGAPORE
        case 6:
            return .DUBAI
        case 7:
            return .AUSTRALIA
        case 8:
            return .STOCKHOLM
        case 9:
            return .AUSTRIA
        case 10:
            return .BRAZIL
        case 11:
            return .SOUTHAFRICA
        case 12:
            return .PW_TEL_SHANGHAI
        case 13:
            return .PW_UNICOM
        case 14:
            return .CHILE
        case 15:
            return .PERU
        case 16:
            return .INDIA
        case 17:
            return .PW_TEL_GUANGDONG
        case 18:
            return .PW_TEL_ZHEJIANG
        case 19:
            return .JAPAN
        case 20:
            return .PW_TEL_WUHAN
        case 25:
            return .PW_TEL_TIANJIN
        case 37:
            return .TAIWAN
        case 38:
            return .ARGENTINA
        default:
            return .UNKNOWN(regionId)
        }
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
