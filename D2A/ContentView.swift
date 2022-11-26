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
        if data.status != .finish {
            LoadingView(status: $data.status) {
                data.loadData()
            }
        } else {
            NavigationHostView()
                .sheet(isPresented: $env.subscriptionSheet, content: {
                    StoreView()
                        .environmentObject(env)
                        .environmentObject(store)
                })
                .alert(isPresented: $env.exceedLimit, content: {
                    Alert(title: Text("Slow down"), message: Text("You are so quick!"), dismissButton: .cancel())
                })
                .alert(isPresented: $env.invalidID, content: {
                    Alert(title: Text("Oops!"), message: Text("Invalid Account ID"), dismissButton: .cancel())
                })
                .alert(isPresented: $env.cantFindUser, content: {
                    Alert(title: Text("Error!"), message: Text("Cannot find this account"), dismissButton: .cancel())
                })
                .alert(isPresented: $env.error, content: {
                    Alert(title: Text("There are something wrong"), message: Text("Please try again"), dismissButton: .cancel())
                })
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DotaEnvironment.shared)
            .environmentObject(HeroDatabase.preview)
    }
}


struct NavigationHostView: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var data: HeroDatabase
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
            if horizontalSizeClass == .compact {
                TabView(selection: $env.selectedTab) {
                    NavigationView {
                        PlayerListView()
                    }.tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(TabSelection.home).navigationViewStyle(.stack)
                    NavigationView {
                        HeroListView()
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
                    PlayerListView()
                }
            }
    }
}
