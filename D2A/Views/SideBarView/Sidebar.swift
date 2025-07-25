//
//  Sidebar.swift
//  App
//
//  Created by Shibo Tong on 17/8/21.
//

import SwiftUI

struct Sidebar: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "favourite = %d", true))
    private var favouritePlayers: FetchedResults<UserProfile>
    
    let heroes: [Hero]

    var body: some View {
        List {
            NavigationLink(
                destination: HomeView()
            ) {
                Label("Home", systemImage: "house")
            }
            NavigationLink(
                destination: HeroListView(heroes: heroes)
            ) {
                Label("Heroes", systemImage: "server.rack")
            }
            NavigationLink(
                destination: LiveMatchListView()
            ) {
                Label("Live", systemImage: "gamecontroller.fill")
            }
            NavigationLink(
                destination: SearchView()
            ) {
                Label("Search", systemImage: "magnifyingglass")
            }

            if !favouritePlayers.isEmpty {
                Section {
                    ForEach(favouritePlayers, id: \.self) { player in
                        NavigationLink(
                            destination: PlayerProfileView(userid: player.id!)
                        ) {
                            SidebarRowView(userid: player.id!)
                        }
                    }
                } header: {
                    Text("Favorite Players")
                }
            }
            NavigationLink(
                destination: AboutUsView()
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
        _profile = FetchRequest<UserProfile>(
            sortDescriptors: [], predicate: NSPredicate(format: "id == %@", userid))
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
                ProfileAvatar(profile: profile, cornerRadius: 10)
                    .frame(width: 30, height: 30)
            }
        } else {
            ProgressView()
        }
    }

}

#if DEBUG
struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Sidebar(heroes: Hero.previewHeroes)
            EmptyView()
        }
        .environmentObject(EnvironmentController.shared)
    }
}
#endif
