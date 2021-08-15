//
//  ContentView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var environment: DotaEnvironment
    @EnvironmentObject var heroData: HeroDatabase
    var body: some View {
        if heroData.loading {
            ProgressView()
        } else {
            NavigationView {
                MatchListView(vm: MatchListViewModel(userid: environment.userID))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(HeroDatabase())
            .environmentObject(DotaEnvironment())
    }
}
