//
//  String.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import SwiftUI

let fontString = "Avenir"
let productIDs = ["D2APRO"]//["D2APlusMonthly", "D2APlusQuarterly", "D2APlusAnnually"]
let GROUP_NAME = "group.D2A"
let TERMS_OF_USE = "https://github.com/shibotong/Dota2Armory/blob/main/Shared/documents/terms-of-use.md"
let PRIVACY_POLICY = "https://github.com/shibotong/Dota2Armory/blob/main/Shared/documents/privacy-policy.md"
let languageCode: Language = {
    let languageStr = Locale.preferredLanguages[0]
    print("Current \(languageStr)")
    switch languageStr {
    case "en":
        return .english
    case "zh-Hans":
        return .sChinese
    default:
        return .english
    }
}()

extension PreviewDevice {

    static let previewDevices = [PreviewDevice.iPodTouch, PreviewDevice.iPhoneSE, PreviewDevice.iPhoneMini, PreviewDevice.iPhone, PreviewDevice.iPhoneProMax]

    static let iPhoneMini = PreviewDevice("iPhone 13 mini")
    static let iPhone = PreviewDevice("iPhone 13")
    static let iPhoneProMax = PreviewDevice("iPhone 13 Pro Max")
    static let iPhoneSE = PreviewDevice("iPhone SE (3rd generation)")
    static let iPodTouch = PreviewDevice("iPod touch (7th generation)")
    static let iPadMini = PreviewDevice("iPad mini (6th generation)")
    static let iPad = PreviewDevice("iPad (9th generation)")
    static let iPadPro = PreviewDevice("iPad Pro (11-inch) (3rd generation)")
    static let iPadPro12 = PreviewDevice("iPad Pro (12-inch) (5th generation)")
}
