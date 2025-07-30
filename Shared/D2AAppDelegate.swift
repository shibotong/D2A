//
//  D2AAppDelegate.swift
//  D2A
//
//  Created by Shibo Tong on 3/7/2025.
//

import UIKit

class D2AAppDelegate: NSObject, UIApplicationDelegate {
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        Task {
            await ImageCache.shared.resetCache()
        }
    }
}
