//
//  VersionManager.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2025.
//

import Foundation

struct VersionManager {
    
    static let shared = VersionManager()
    
    var isNewInstalled: Bool {
        lastVersion == nil
    }
    
    var isUpdated: Bool {
        lastVersion != nil && lastVersion != appVersion
    }
    
    let lastVersion: String?
    let appVersion: String
    
    init(userDefaults: UserDefaults? = UserDefaults(suiteName: GROUP_NAME), logger: D2ALogger = .shared) {
        lastVersion = userDefaults?.string(forKey: "dotaArmory.appVersion")
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            logger.critical("Current app version is not applicable", category: .app)
            self.appVersion = "0.0.0"
            return
        }
        self.appVersion = appVersion
        if appVersion != lastVersion {
            userDefaults?.setValue(appVersion, forKey: "dotaArmory.appVersion")
        }
    }
    
    init(lastVersion: String?, appVersion: String) {
        self.lastVersion = lastVersion
        self.appVersion = appVersion
    }
}
