//
//  AppApp.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI

@main
struct AppApp: App {
    @StateObject var environment: DotaEnvironment = DotaEnvironment.shared
    @StateObject var heroDatabase: HeroDatabase = HeroDatabase.shared
    
    let coreDataController = CoreDataController.shared
    
    @State private var selectedUser: String = ""
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(environment)
                .environmentObject(heroDatabase)
                .environment(\.managedObjectContext, coreDataController.container.viewContext)
//            PlayerDetailView(player: Match.sample.players.first!)
        }
    }
}
