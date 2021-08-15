//
//  AppApp.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI

@main
struct AppApp: App {
    @StateObject var environment: DotaEnvironment = DotaEnvironment()
    @StateObject var heroDatabase: HeroDatabase = HeroDatabase.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(environment)
                .environmentObject(heroDatabase)
//            PlayerDetailView(player: Match.sample.players.first!)
        }
    }
}
