//
//  SyncingTimer.swift
//  D2A
//
//  Created by Shibo Tong on 16/4/2026.
//

import Foundation

protocol SyncingTimerProtocol {
    func shouldSync(key: SyncingTimerKey) -> Bool
    func finishSyncing(key: SyncingTimerKey)
    func resetSyncing()
}

enum SyncingTimerKey {
    case constants
    case localization(DataLanguageEnum)
    
    var key: String {
        switch self {
        case .constants:
            return "constants"
        case .localization(let dataLanguageEnum):
            return "localization_\(dataLanguageEnum.rawValue)"
        }
    }
}

class SyncingTimer: SyncingTimerProtocol {
    
    private let userDefaults: UserDefaults
    private let dateProvider: () -> Date
    
    static let shared = SyncingTimer()
    
    init(userDefaults: UserDefaults = .standard,
         dateProvider: @escaping () -> Date = { Date () }) {
        self.userDefaults = userDefaults
        self.dateProvider = dateProvider
    }
    
    func shouldSync(key: SyncingTimerKey) -> Bool {
        guard let lastDate = userDefaults.value(forKey: key.key) as? Date else {
            return true
        }
        return !lastDate.isToday
    }
    
    func finishSyncing(key: SyncingTimerKey) {
        let date = dateProvider()
        userDefaults.set(date, forKey: key.key)
    }
    
    func resetSyncing() {
        userDefaults.set(nil, forKey: SyncingTimerKey.constants.key)
        for language in DataLanguageEnum.allCases {
            userDefaults.set(nil, forKey: SyncingTimerKey.localization(language).key)
        }
    }
}
