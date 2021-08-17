//
//  ContentView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var environment: DotaEnvironment
    @EnvironmentObject var heroData: HeroDatabase
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
//        if horizontalSizeClass == .compact {
            NavigationView {
                Sidebar()
                if environment.selectedUserProfile == nil {
                    ProgressView()
                } else {
                    MatchListView()
                }
                if environment.selectedGame == nil {
                    Text("Select a match")
                } else {
                    MatchView()
                }
            }//.navigationViewStyle(StackNavigationViewStyle())
//        } else {
//            NavigationView {
//                Sidebar()
//                if environment.selectedUser == nil {
//                    ProgressView()
//                } else {
//                    MatchListView(vm: MatchListViewModel(userid: environment.selectedUser!)).equatable()
//                }
//                if environment.selectedGame == nil {
//                    Text("Select a match")
//                } else {
//                    MatchView(vm: MatchViewModel(match: environment.selectedGame!))
//                }
//            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(HeroDatabase())
            .environmentObject(DotaEnvironment())
    }
}
