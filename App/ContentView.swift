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
        if data.loading {
            LoadingView()
                .frame(width: 50, height: 50)
                .alert("An Error Occured", isPresented: $data.error) {
                    Button("OK", role: .cancel) {
                        exit(0)
                    }
                }
        } else {
            NavigationHostView()
                .sheet(isPresented: $env.addNewAccount, content: {
                    AddAccountView()
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
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DotaEnvironment.shared)
            .environmentObject(HeroDatabase.shared)
    }
}


struct NavigationHostView: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var data: HeroDatabase
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @AppStorage("selectedUser") var selectedUser: String?
    @AppStorage("selectedMatch") var selectedMatch: String?
    
    private var sheetHeight: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        // image size: 256 * 144
        let imageHeight = screenHeight - screenWidth / 256 * 144 - 50
        return imageHeight
    }
    
    var body: some View {
//        if env.userIDs.isEmpty {
//            EmptyUserView()
//        } else {
            if horizontalSizeClass == .compact {
                TabView(selection: $env.selectedTab) {
                    NavigationView {
                        PlayerListView()
                    }.tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }.tag(TabSelection.home)
                    NavigationView {
                        HeroListView()
                    }.tabItem {
                        Image(systemName: "server.rack")
                        Text("Hero")
                    }.tag(TabSelection.hero)

                    AddAccountView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }.tag(TabSelection.search)
                    NavigationView {
                        EmptyView()
                    }.tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }.tag(TabSelection.setting)
                }
//                .bottomSheet(item: $env.selectedAbility, height: sheetHeight, topBarCornerRadius: 30, content: { ability in
//                    AbilityView(ability: ability.ability, heroID: ability.heroID, abilityName: ability.abilityName)
//                })
            } else {
                NavigationView {
                    Sidebar()
                    EmptyView()
                }
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
            }
//        }
    }
}

extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.show(.primary)
    }
}
