//
//  D2AApp.swift
//  D2A
//
//  Created by Shibo Tong on 11/8/21.
//

import CoreData
import SwiftData
import StoreKit
import SwiftUI

@main
struct D2AApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: D2AAppDelegate
    @StateObject var environment: EnvironmentController = EnvironmentController.shared
    @StateObject var constantsController: ConstantsController = ConstantsController.shared
    @StateObject var storeManager: StoreManager = StoreManager.shared
    @StateObject var imageController: ImageController = ImageController.shared
    @StateObject var gameDataController: GameDataController = GameDataController.shared
    #if DEBUG
        @StateObject var logger: D2ALogger = D2ALogger.shared
    #endif
    let persistanceController = PersistanceProvider.shared
    @AppStorage("selectedMatch") var selectedMatch: String?
    @AppStorage("selectedUser") var selectedUser: String?

    init() {
        PlayerTransformer.register()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(persistanceController.modelContainer)
                .environmentObject(environment)
                .environmentObject(constantsController)
                .environmentObject(storeManager)
                .environmentObject(imageController)
                .environmentObject(gameDataController)
                #if DEBUG
                    .environmentObject(logger)
                #endif
                .environment(\.managedObjectContext, persistanceController.mainContext)
                .onOpenURL { url in
                    print(url.absoluteString)
                    environment.userActive = false
                    environment.matchActive = false
                    guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                        let params = components.queryItems
                    else {
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
