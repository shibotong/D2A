//
//  Sidebar.swift
//  App
//
//  Created by Shibo Tong on 17/8/21.
//

import SwiftUI

struct Sidebar: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var data: HeroDatabase
    @AppStorage("selectedUser") var selectedUser: String?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        List {
            NavigationLink(
                destination: PlayerListView(),
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
            
            if env.registerdID != "" || !env.userIDs.isEmpty {
                Section {
                    if env.registerdID != "" {
                        NavigationLink(
                            destination: PlayerProfileView(vm: PlayerProfileViewModel(userid: env.registerdID)),
                            tag: env.registerdID,
                            selection: $selectedUser
                        ) {
                            SidebarRowView(userid: env.registerdID)
                        }.isDetailLink(true)
                    }
                    ForEach(env.userIDs, id: \.self) { id in
                        NavigationLink(
                            destination: PlayerProfileView(vm: PlayerProfileViewModel(userid: id)),
                            tag: id,
                            selection: $selectedUser
                        ) {
                            SidebarRowView(userid: id)
                        }.isDetailLink(true)
                    }
                    .onMove(perform: { indices, newOffset in
                        env.move(from: indices, to: newOffset)
                    })
                    .onDelete(perform: { indexSet in
                        env.delete(from: indexSet)
                    })
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
        _profile = FetchRequest<UserProfile>(sortDescriptors: [], predicate: NSPredicate(format: "id == %d", Int(userid)!))
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
                ProfileAvartar(profile: profile, sideLength: 30, cornerRadius: 10)
            }
        } else {
            ProgressView()
        }
    }
    
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Sidebar()
                .environmentObject(DotaEnvironment.preview)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
