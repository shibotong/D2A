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
    
    static let hero = LocalizedStringKey("HERO")
    
    // MARK: - Search
    static let search = LocalizedStringKey("Search")
    static let searchPageTitle = LocalizedStringKey("SearchPageTitle")
    static let searchPageSubtitle = LocalizedStringKey("SearchPageSubtitle")
    static let recentlySearched = LocalizedStringKey("RecentSearch")
    static let clear = LocalizedStringKey("Clear")
    static let clearSearchTitle = LocalizedStringKey("ClearSearchTitle")
    static let clearSearchDescription = LocalizedStringKey("ClearSearchDescription")
    static let clearSearchButton = LocalizedStringKey("ClearSearchButtonTitle")
    
    static let cancel = LocalizedStringKey("Cancel")
}
