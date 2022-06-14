//
//  Sidebar.swift
//  App
//
//  Created by Shibo Tong on 17/8/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct Sidebar: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var data: HeroDatabase
    @AppStorage("selectedUser") var selectedUser: String?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        List {
            Text("Home")
            NavigationLink(destination: PlayerListView(vm: PlayerListViewModel(registeredID: env.registerdID, followedID: env.userIDs))) {
                Label {
                    Text("Home")
                } icon: {
                    Image(systemName: "person.fill")
                }
            }
            
            
            if env.registerdID != "" {
                SidebarRowView(vm: SidebarRowViewModel(userid: env.registerdID))
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
        }
        .navigationTitle("Follow")
        .listStyle(SidebarListStyle())
    }
}

struct SidebarRowView: View {
    @ObservedObject var vm: SidebarRowViewModel
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
                Text("\(vm.profile!.personaname)").lineLimit(1)
            } icon: {
                WebImage(url: URL(string: vm.profile!.avatarfull))
                    .resizable()
                    .renderingMode(.original)
                    .indicator(.activity)
                    .transition(.fade)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
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
                .environmentObject(DotaEnvironment.shared)
        }
    }
}
