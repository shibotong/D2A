//
//  LocalizableStrings.swift
//  App
//
//  Created by Shibo Tong on 21/9/21.
//

import Foundation
import SwiftUI

struct LocalizableStrings {
    static let kills = NSLocalizedString("Kills", comment: "")
    static let towerDamage = NSLocalizedString("Tower Damage", comment: "")
    static let heroDamage = NSLocalizedString("Hero Damage", comment: "")
    static let gold = NSLocalizedString("Net Worth", comment: "")
    
    
    // MARK: - Search
    static let recentlySearched = LocalizedStringKey("RECENT_SEARCH")
    static let clear = LocalizedStringKey("CLEAR")
    static let clearSearchTitle = LocalizedStringKey("CLEARSEARCHTITLE")
    static let clearSearchDescription = LocalizedStringKey("CLEARSEARCHDESCRIPTION")
    static let clearSearchButton = LocalizedStringKey("CLEARSEARCHBUTTON")
    
    static let cancel = LocalizedStringKey("CANCEL")
}
