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
    var body: some View {
        List {
            ForEach(env.userIDs, id: \.self) { id in
                        SidebarRowView(vm: SidebarRowViewModel(userid: id))
            

            }
        }
        .navigationTitle("Follow")
        .listStyle(SidebarListStyle())
    }
}

struct SidebarRowView: View {
    @ObservedObject var vm: SidebarRowViewModel
    var body: some View {
        if vm.profile != nil {
            NavigationLink(destination: MatchListView(vm: MatchListViewModel(userid: vm.userid)).navigationTitle("\(vm.profile!.personaname)")) {
                Label {
                    Text("\(vm.profile!.personaname)")
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
            }
        } else {
            ProgressView()
        }
    }
    
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
