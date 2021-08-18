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
        NavigationView {
            Sidebar()
        }
//        if horizontalSizeClass == .compact {
//            NavigationView {
//                Sidebar()
//                if environment.selectedUserProfile == nil {
//                    ProgressView()
//                } else {
//                    MatchListView()
//                }
////                if environment.selectedGame == nil {
////                    Text("Select a match")
////                } else {
////                    MatchView()
////                }
//            }//.navigationViewStyle(StackNavigationViewStyle())
//            .sheet(isPresented: $environment.exceedLimit) {
//                Text("exceedLimit")
//            }
//        } else {
//            NavigationView {
//                Sidebar()
//                if environment.selectedUserProfile == nil {
//                    ProgressView()
//                } else {
//                    MatchListView()
//                }
//                if environment.selectedGame == nil {
//                    Text("Select a match")
//                } else {
//                    MatchView(id: 0)
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
