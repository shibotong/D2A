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
    @AppStorage("selectedUser") var selectedUser: String?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        List {
            ForEach(env.userIDs, id: \.self) { id in
                NavigationLink(
                    destination: MatchListView(vm: MatchListViewModel(userid: id)),
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
        .navigationBarItems(leading: Button("+ Add") {
            env.addNewAccount.toggle()
        }, trailing: EditButton())
        .listStyle(SidebarListStyle())
        //            .toolbar {
        //                ToolbarItem(placement: .bottomBar) {
        //                    Button("+ Add") {
        //                        env.addNewAccount.toggle()
        //                    }
        //                }
        //            }
    }
}

struct SidebarRowView: View {
    @ObservedObject var vm: SidebarRowViewModel
    var body: some View {
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
        Sidebar()
            .environmentObject(DotaEnvironment.shared)
    }
}
