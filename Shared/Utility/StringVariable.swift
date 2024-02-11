//
//  String.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import SwiftUI
import StratzAPI

var refreshDistance: TimeInterval {
    var refreshTime: TimeInterval = 60
    #if DEBUG
    refreshTime = 1
    #endif
    return refreshTime
}

/// True if running tests
let isTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil

/// True is running UITest
let uiTesting = ProcessInfo.processInfo.arguments.contains("uitest")

let languageCode: Language = {
    switch StringVariable.currentLanguage {
    case "en":
        return .english
    case "zh":
        return .sChinese
    default:
        return .english
    }
}()

let colonLocalize: Character = {
    switch StringVariable.currentLanguage {
    case "en":
        return ":"
    case "zh":
        return "："
    default:
        return ":"
    }
}()

struct StringVariable {
    static let productIDs = ["D2APRO"]// ["D2APlusMonthly", "D2APlusQuarterly", "D2APlusAnnually"]
    static let GROUP_NAME = "group.D2A"
    static let TERMS_OF_USE = "https://github.com/shibotong/Dota2Armory/blob/main/Shared/Documents/terms-of-use.md"
    static let PRIVACY_POLICY = "https://github.com/shibotong/Dota2Armory/blob/main/Shared/Documents/privacy-policy.md"
    static let currentLanguage: String = Locale.current.languageCode ?? "en"
    static let imagePrefixURL = "https://cdn.cloudflare.steamstatic.com"
}

extension PreviewDevice: Identifiable {
    
    public var id: String {
        return rawValue
    }

    static let iPhoneDevices = [PreviewDevice.iPhoneSE, PreviewDevice.iPhone, PreviewDevice.iPhoneProMax]

    static let iPadDevies = [PreviewDevice.iPadMini, PreviewDevice.iPad]
    
    static let iPhone = PreviewDevice("iPhone 15")
    static let iPhoneProMax = PreviewDevice("iPhone 14 Pro Max")
    static let iPhoneSE = PreviewDevice("iPhone SE (3rd generation)")
    static let iPadMini = PreviewDevice("iPad mini (6th generation)")
    static let iPad = PreviewDevice("iPad (10th generation)")
    static let iPadPro = PreviewDevice("iPad Pro (11-inch)")
    static let iPadPro12 = PreviewDevice("iPad Pro (12.9-inch) (6th generation")
}
