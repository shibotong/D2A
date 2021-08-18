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
                NavigationLink(
                    destination: MatchListView(vm: MatchListViewModel(userid: id)),
                    tag: id,
                    selection: $env.selectedUserID,
                    label: {
                        SidebarRowView(vm: SidebarRowViewModel(userid: id)).equatable()
                    })
//                    .simultaneousGesture(TapGesture().onEnded{
//                        print("switch user")
//                        env.loadUser(id: id)
//                    })
            }
        }
        .navigationTitle("Follow")
        .listStyle(SidebarListStyle())
    }
}

struct SidebarRowView: View, Equatable {
    @ObservedObject var vm: SidebarRowViewModel
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(entity: UserProfile.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)], predicate: NSPredicate(format: "id == %@", 153041957)) private var userprofile: FetchedResults<UserProfile>
    var body: some View {
        if vm.profile != nil {
            Label {
                Text("\(vm.profile!.personaname!)")
            } icon: {
                WebImage(url: URL(string: vm.profile!.avatarfull!))
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
    
    static func == (lhs: SidebarRowView, rhs: SidebarRowView) -> Bool {
        return lhs.vm.userid == rhs.vm.userid
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
