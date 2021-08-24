//
//  ContentView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var env: DotaEnvironment
    var body: some View {
        NavigationHostView()
            .sheet(isPresented: $env.addNewAccount, content: {
                AddAccountView()
                    .equatable()
                    .environmentObject(env)
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
                    MatchListView(vm: MatchListViewModel(userid: selectedUser))
                        .frame(minWidth: 320)
                    MatchView(vm: MatchViewModel(matchid: selectedMatch))
                }
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
            }
        }
    }
}
