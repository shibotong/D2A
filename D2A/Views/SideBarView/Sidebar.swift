//
//  Sidebar.swift
//  App
//
//  Created by Shibo Tong on 17/8/21.
//

import SwiftUI

struct Sidebar: View {
    @EnvironmentObject var env: DotaEnvironment
    @AppStorage("selectedUser") var selectedUser: String?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @FetchRequest(sortDescriptors: [],
                  predicate: NSPredicate(format: "favourite = %d", true))
    private var favouritePlayers: FetchedResults<UserProfile>
    
    var body: some View {
        List {
            NavigationLink(
                destination: HomeView(),
                tag: TabSelection.home,
                selection: $env.iPadSelectedTab
            ) {
                Label("Home", systemImage: "house")
            }
            NavigationLink(
                destination: HeroListView(),
                tag: TabSelection.hero,
                selection: $env.iPadSelectedTab
            ) {
                Label("Heroes", systemImage: "server.rack")
            }
            NavigationLink(
                destination: SearchView(),
                tag: TabSelection.search,
                selection: $env.iPadSelectedTab
            ) {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            if !favouritePlayers.isEmpty {
                Section {
                    ForEach(favouritePlayers, id: \.self) { player in
                        NavigationLink(
                            destination: PlayerProfileView(userid: player.id!),
                            tag: player.id!,
                            selection: $selectedUser
                        ) {
                            SidebarRowView(userid: player.id!)
                        }.isDetailLink(true)
                    }
//                    .onMove(perform: { indices, newOffset in
//                        env.move(from: indices, to: newOffset)
//                    })
//                    .onDelete(perform: { indexSet in
//                        env.delete(from: indexSet)
//                    })
                } header: {
                    Text("Favorite Players")
                }
            }
            NavigationLink(
                destination: AboutUsView(),
                tag: TabSelection.setting,
                selection: $env.iPadSelectedTab
            ) {
                Label("About", systemImage: "info.circle")
            }
        }
        .navigationTitle("D2A")
        .listStyle(SidebarListStyle())
    }
}

struct SidebarRowView: View {
    @FetchRequest var profile: FetchedResults<UserProfile>
    
    init(userid: String) {
        _profile = FetchRequest<UserProfile>(sortDescriptors: [], predicate: NSPredicate(format: "id == %@", userid))
    }
    
    var body: some View {
        makeUI()
    }
    
    @ViewBuilder
    func makeUI() -> some View {
        if let profile = profile.first {
            Label {
                Text("\(profile.name ?? profile.personaname ?? "")").lineLimit(1)
            } icon: {
                ProfileAvartar(profile: profile, cornerRadius: 10)
                    .frame(width: 30, height: 30)
            }
        } else {
            ProgressView()
        }
    }
    
}
//
//struct Sidebar_Previews: PreviewProvider {
//    static var previews: some View {
//        Text("Hello world")
//    }
//}
