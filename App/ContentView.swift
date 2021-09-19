//
//  ContentView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var data: HeroDatabase
    @EnvironmentObject var store: StoreManager
    var body: some View {
        NavigationHostView()
            .sheet(isPresented: $env.addNewAccount, content: {
                AddAccountView()
                    .equatable()
                    .environmentObject(env)
            })
            .sheet(isPresented: $env.aboutUs, content: {
                AboutUsView()
                    .environmentObject(env)
            })
            .sheet(isPresented: $env.subscriptionSheet, content: {
                StoreView()
                    .environmentObject(env)
                    .environmentObject(store)
            })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DotaEnvironment.shared)
    }
}


struct NavigationHostView: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var data: HeroDatabase
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @AppStorage("selectedUser") var selectedUser: String?
    @AppStorage("selectedMatch") var selectedMatch: String?
    var body: some View {
        if env.userIDs.isEmpty {
            EmptyUserView()
        } else {
            if horizontalSizeClass == .compact {
                NavigationView {
                    Sidebar()
                }
            } else {
                NavigationView {
                    Sidebar()
                    MatchListView(vm: MatchListViewModel(userid: selectedUser)).equatable()
                        .frame(minWidth: 320)
                    MatchView(vm: MatchViewModel(matchid: selectedMatch))
                }
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
                
            }
        }
    }
}
