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
    
    #if DEBUG
    @EnvironmentObject var hudController: HUDController
    #endif
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var text = ""

    var body: some View {
        if horizontalSizeClass == .compact {
            ZStack {
                TabView(selection: $env.selectedTab) {
                    NavigationView {
                        HomeView()
                    }
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(TabSelection.home)
                    
                    NavigationView {
                        HeroListContainer()
                    }
                    .tabItem {
                        Image(systemName: "server.rack")
                        Text("Heroes")
                    }
                    .tag(TabSelection.hero)

                    NavigationView {
                        SearchView()
                            .searchable(text: $text)
                    }
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(TabSelection.search)
                    
                    NavigationView {
                        AboutUsView()
                    }
                    .tabItem {
                        Image(systemName: "ellipsis")
                        Text("More")
                    }
                    .tag(TabSelection.setting)
                }
                #if DEBUG
                if hudController.huds.count > 0 {
                    ScrollView {
                        VStack {
                            ForEach(hudController.huds, id: \.title) { progress in
                                HUDView(progress: progress)
                            }
                        }
                    }
                }
                #endif
            }
        } else {
            NavigationView {
                Sidebar()
                HomeView()
            }
        }
    }
}

#Preview {
    NavigationHostView()
        .environmentObject(EnvironmentController.preview)
        .environmentObject(ConstantsController.preview)
        .environmentObject(HUDController(huds: [HUDProgress(title: "TEST HUD", total: 100, current: 1)]))
}
