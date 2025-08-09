//
//  ContentView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import StoreKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var env: EnvironmentController
    @EnvironmentObject var constants: ConstantsController
    @EnvironmentObject var store: StoreManager
    var body: some View {
        Group {
            NavigationHostView()
                .sheet(
                    isPresented: $env.subscriptionSheet,
                    content: {
                        StoreView()
                            .environmentObject(env)
                            .environmentObject(store)
                    })
        }
        .alert(
            isPresented: $env.error,
            content: {
                Alert(
                    title: Text("Error"), message: Text(env.errorMessage), dismissButton: .cancel())
            })
        .task {
            await constants.loadData()
        }
    }
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(EnvironmentController.shared)
//            .environmentObject(ConstantsController.preview)
//    }
// }

struct NavigationHostView: View {
    @EnvironmentObject var env: EnvironmentController
    @EnvironmentObject var data: ConstantsController
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @FetchRequest(entity: Hero.entity(), sortDescriptors: [])
    private var heroes: FetchedResults<Hero>
    
    private var sortedHeroes: [Hero] {
        return Array(heroes).sorted(by: { $0.heroNameLocalized < $1.heroNameLocalized })
    }

    var body: some View {
        if horizontalSizeClass == .compact {
            TabView(selection: $env.selectedTab) {
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(TabSelection.home)

                NavigationStack {
                    HeroListView(heroes: sortedHeroes)
                }
                .tabItem {
                    Image(systemName: "server.rack")
                    Text("Heroes")
                }
                .tag(TabSelection.hero)

                NavigationStack {
                    LiveMatchListView()
                }
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Live")
                }
                .tag(TabSelection.live)

                NavigationStack {
                    SearchView()
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(TabSelection.search)

                NavigationStack {
                    AboutUsView()
                }
                .tabItem {
                    Image(systemName: "ellipsis")
                    Text("More")
                }
                .tag(TabSelection.setting)
            }
        } else {
            NavigationSplitView {
                Sidebar(heroes: sortedHeroes)
            } detail: {
                NavigationStack {
                    HomeView()
                }
            }

        }
    }
}
