//
//  ContentView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var heroData: HeroDatabase
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @AppStorage("selectedUser") var selectedUser: String?
    @AppStorage("selectedMatch") var selectedMatch: String?
    var body: some View {
        if horizontalSizeClass == .compact {
            NavigationView {
                Sidebar()
            }
        } else {
            NavigationView {
                Sidebar()
                MatchListView(vm: MatchListViewModel(userid: selectedUser))
                MatchView(vm: MatchViewModel(matchid: selectedMatch))
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(HeroDatabase())
    }
}
