//
//  Region.swift
//  D2A
//
//  Created by Shibo Tong on 13/9/2026.
//

import Foundation
import SwiftUI

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
    case PW_UNI_TIANJIN
    case TAIWAN
    case ARGENTINA
    case UNKNOWN
    
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
            return .PW_UNI_TIANJIN
        case 37:
            return .TAIWAN
        case 38:
            return .ARGENTINA
        default:
            return .UNKNOWN
        }
    }
    
    var localized: String {
        return NSLocalizedString(rawValue, tableName: "Region", comment: "")
    }
}
