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
    @EnvironmentObject var syncingService: StaticDataSyncingService
    
    @FetchRequest(sortDescriptors: [])
    private var heroes: FetchedResults<Hero>
    
    var body: some View {
        Group {
            if data.status != .finish || env.loading == true {
                MainLoadingView(status: $data.status,
                                envLoading: env.loading) {
                    data.loadData()
                }
            } else {
                NavigationHostView(heroes: Array(heroes))
                    .sheet(isPresented: $env.subscriptionSheet, content: {
                        StoreView()
                            .environmentObject(env)
                            .environmentObject(store)
                    })
            }
        }
        .alert(isPresented: $env.error, content: {
            Alert(title: Text("Error"), message: Text(env.errorMessage), dismissButton: .cancel())
        })
        .task {
            try? await syncingService.startSyncing()
        }
    }
}

struct NavigationHostView: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var data: HeroDatabase
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    let heroes: [Hero]
    
    var body: some View {
            if horizontalSizeClass == .compact {
                TabView(selection: $env.selectedTab) {
                    NavigationView {
                        HomeView()
                    }.tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(TabSelection.home).navigationViewStyle(.stack)
                    NavigationView {
                        HeroListView(heroes: heroes)
                            .navigationTitle("Heroes")
                    }.tabItem {
                        Image(systemName: "server.rack")
                        Text("Heroes")
                    }.tag(TabSelection.hero).navigationViewStyle(.stack)
                    NavigationView {
                        SearchView()
                    }
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }.tag(TabSelection.search).navigationViewStyle(.stack)
                    NavigationView {
                        AboutUsView()
                    }
                    .tabItem {
                        Image(systemName: "ellipsis")
                        Text("More")
                    }.tag(TabSelection.setting).navigationViewStyle(.stack)
                }
            } else {
                NavigationView {
                    Sidebar()
                    HomeView()
                }
            }
    }
}
