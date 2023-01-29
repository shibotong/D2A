//
//  D2AApp.swift
//  D2A
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI
import StoreKit
import CoreData

@main
struct D2AApp: App {
    @StateObject var environment: DotaEnvironment = DotaEnvironment.shared
    @StateObject var heroDatabase: HeroDatabase = HeroDatabase.shared
    @StateObject var storeManager: StoreManager = StoreManager.shared
    let persistenceController = PersistenceController.shared
    @AppStorage("selectedMatch") var selectedMatch: String?
    @AppStorage("selectedUser") var selectedUser: String?
    
    init() {
        PlayerTransformer.register()
    }
    
    var body: some Scene {
        WindowGroup {
//            LatestRecentMatchView(userid: "preview")
//                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            ContentView()
                .environmentObject(environment)
                .environmentObject(heroDatabase)
                .environmentObject(storeManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    print(url.absoluteString)
                    environment.userActive = false
                    environment.matchActive = false
                    guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                        let params = components.queryItems else {
                            print("Invalid URL or album path missing")
                            return
                    }
                    print(params)
                    if let purchase = params.first(where: { $0.name == "purchase" })?.value {
                        if purchase == "true" {
                            environment.subscriptionSheet = true
                        }
                    }
                    if let userid = params.first(where: { $0.name == "userid" })?.value {
                        if userid != "0" {
                            environment.tab = .search
                            environment.userActive = true
                            environment.selectedUser = userid
                        }
                    }
                    if let matchid = params.first(where: { $0.name == "matchid" })?.value {
                        environment.tab = .search
                        environment.matchActive = true
                        environment.selectedMatch = matchid
                    }
                }
        }
    }
}
