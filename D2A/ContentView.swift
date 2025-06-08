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
        Group {
            NavigationHostView()
                .sheet(isPresented: $env.subscriptionSheet, content: {
                    StoreView()
                        .environmentObject(env)
                        .environmentObject(store)
                })
        }
        .alert(isPresented: $env.error, content: {
            Alert(title: Text("Error"), message: Text(env.errorMessage), dismissButton: .cancel())
        })
    }
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(DotaEnvironment.shared)
//            .environmentObject(HeroDatabase.preview)
//    }
// }

struct NavigationHostView: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var data: HeroDatabase
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabView(selection: $env.selectedTab) {
                D2ANavigationStack {
                    HomeView()
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(TabSelection.home)
                
                D2ANavigationStack {
                    HeroListView()
                }
                .tabItem {
                    Image(systemName: "server.rack")
                    Text("Heroes")
                }
                .tag(TabSelection.hero)
                
                D2ANavigationStack {
                    LiveMatchListView()
                }
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Live")
                }
                .tag(TabSelection.live)
                
                D2ANavigationStack {
                    SearchView()
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(TabSelection.search)
                
                D2ANavigationStack {
                    AboutUsView()
                }
                .tabItem {
                    Image(systemName: "ellipsis")
                    Text("More")
                }
                .tag(TabSelection.setting)
            }
        } else {
            D2ANavigationSplitView {
                Sidebar()
            } detail: {
                HomeView()
            }

        }
    }
}
