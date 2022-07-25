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
                Label {
                    Text("Home")
                } icon: {
                    Image(systemName: "house")
                }
            }
            NavigationLink(
                destination: HeroListView(),
                tag: TabSelection.hero,
                selection: $env.iPadSelectedTab
            ) {
                Label {
                    Text("Heroes")
                } icon: {
                    Image(systemName: "server.rack")
                }
            }
            NavigationLink(
                destination: SearchView(),
                tag: TabSelection.search,
                selection: $env.iPadSelectedTab
            ) {
                Label {
                    Text("Search")
                } icon: {
                    Image(systemName: "magnifyingglass")
                }
            }
            
            if env.registerdID != "" || !env.userIDs.isEmpty {
                Section {
                    if env.registerdID != "" {
                        NavigationLink(
                            destination: PlayerProfileView(vm: PlayerProfileViewModel(userid: env.registerdID)),
                            tag: env.registerdID,
                            selection: $selectedUser
                        ) {
                            SidebarRowView(vm: SidebarRowViewModel(userid: env.registerdID))
                        }.isDetailLink(true)
                    }
                    ForEach(env.userIDs, id: \.self) { id in
                        NavigationLink(
                            destination: PlayerProfileView(vm: PlayerProfileViewModel(userid: id)),
                            tag: id,
                            selection: $selectedUser
                        ) {
                            SidebarRowView(vm: SidebarRowViewModel(userid: id))
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
                Label {
                    Text("About Us")
                } icon: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .navigationTitle("D2A")
        .listStyle(SidebarListStyle())
    }
}

struct SidebarRowView: View {
    @StateObject var vm: SidebarRowViewModel
    var body: some View {
        makeUI()
            .task {
                vm.loadProfile()
            }
    }
    
    @ViewBuilder
    func makeUI() -> some View {
        if vm.profile != nil {
            Label {
                Text("\(vm.profile?.name ?? vm.profile!.personaname)").lineLimit(1)
            } icon: {
                ProfileAvartar(image: vm.userIcon, sideLength: 30, cornerRadius: 10)
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
