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
//                .frame(width: 50, height: 50)
//                .alert("An Error Occured", isPresented: $data.error) {
//                    Button("OK", role: .cancel) {
//                        exit(0)
//                    }
//                }
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
                .alert(isPresented: $env.exceedLimit, content: {
                    Alert(title: Text("Slow down"), message: Text("You are so quick!"), dismissButton: .cancel())
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
    
    var body: some View {
            if horizontalSizeClass == .compact {
                TabView(selection: $env.selectedTab) {
                    NavigationView {
                        PlayerListView(vm: PlayerListViewModel(registeredID: env.registerdID, followedID: env.userIDs))
                    }.tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }.tag(TabSelection.home).navigationViewStyle(.stack)
                    NavigationView {
                        HeroListView()
                    }.tabItem {
                        Image(systemName: "server.rack")
                        Text("Hero")
                    }.tag(TabSelection.hero).navigationViewStyle(.stack)

                    AddAccountView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }.tag(TabSelection.search).navigationViewStyle(.stack)
                    

                    AboutUsView()
                        .tabItem {
                            Image(systemName: "ellipsis")
                            Text("More")
                        }.tag(TabSelection.setting).navigationViewStyle(.stack)
                }
            } else {
                NavigationView {
                    Sidebar()
                    EmptyView()
                }
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
            }
    }
}

extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.show(.primary)
    }
}
