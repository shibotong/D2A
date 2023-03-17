//
//  String.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import SwiftUI
import StratzAPI

let productIDs = ["D2APRO"]// ["D2APlusMonthly", "D2APlusQuarterly", "D2APlusAnnually"]
let GROUP_NAME = "group.D2A"
let TERMS_OF_USE = "https://github.com/shibotong/Dota2Armory/blob/main/Shared/documents/terms-of-use.md"
let PRIVACY_POLICY = "https://github.com/shibotong/Dota2Armory/blob/main/Shared/documents/privacy-policy.md"
let currentLanguage: String = Locale.current.languageCode ?? "en"
let languageCode: Language = {
    switch currentLanguage {
    case "en":
        return .english
    case "zh":
        return .sChinese
    default:
        return .english
    }
}()
let colonLocalize: Character = {
    switch currentLanguage {
    case "en":
        return ":"
    case "zh":
        return "："
    default:
        return ":"
    }
}()

var refreshDistance: TimeInterval {
    var refreshTime: TimeInterval = 60
    #if DEBUG
    refreshTime = 1
    #endif
    return refreshTime
}

extension PreviewDevice {

    static let previewDevices = [PreviewDevice.iPodTouch, PreviewDevice.iPhoneSE, PreviewDevice.iPhoneMini, PreviewDevice.iPhone, PreviewDevice.iPhoneProMax]

    static let iPhoneMini = PreviewDevice("iPhone 13 mini")
    static let iPhone = PreviewDevice("iPhone 13")
    static let iPhoneProMax = PreviewDevice("iPhone 13 Pro Max")
    static let iPhoneSE = PreviewDevice("iPhone SE (3rd generation)")
    static let iPodTouch = PreviewDevice("iPod touch (7th generation)")
    static let iPadMini = PreviewDevice("iPad mini (6th generation)")
    static let iPad = PreviewDevice("iPad (10th generation)")
    static let iPadPro = PreviewDevice("iPad Pro (11-inch) (3rd generation)")
    static let iPadPro12 = PreviewDevice("iPad Pro (12-inch) (5th generation)")
}
