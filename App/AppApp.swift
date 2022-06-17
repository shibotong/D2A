//
//  AppApp.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI
import StoreKit

@main
struct AppApp: App {
    @StateObject var environment: DotaEnvironment = DotaEnvironment.shared
    @StateObject var heroDatabase: HeroDatabase = HeroDatabase.shared
    @StateObject var storeManager: StoreManager = StoreManager.shared
    @AppStorage("selectedMatch") var selectedMatch: String?
    @AppStorage("selectedUser") var selectedUser: String?
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(environment)
                .environmentObject(heroDatabase)
                .environmentObject(storeManager)
                .onOpenURL { url in
                    print(url.absoluteString)
                    environment.userActive = false
                    environment.matchActive = false
                    guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                        let params = components.queryItems else {
                            print("Invalid URL or album path missing")
                            return //false
                    }
                    print(params)
                    if let userid = params.first(where: { $0.name == "userid" })?.value {
                        if userid != "0" {
                            environment.selectedTab = .search
                            environment.iPadSelectedTab = .search
                            environment.userActive = true
                            environment.selectedUser = userid
                        }
                    }
                    
                    if let matchid = params.first(where: { $0.name == "matchid" })?.value {
                        environment.selectedTab = .search
                        environment.iPadSelectedTab = .search
                        environment.matchActive = true
                        environment.selectedMatch = matchid
                    }
                }
        }
    }
}
