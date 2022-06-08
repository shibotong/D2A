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
            ForEach(env.userIDs, id: \.self) { id in
                NavigationLink(
                    destination: MatchListView(vm: MatchListViewModel(userid: id)).equatable(),
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
        .navigationBarItems(leading: Button(action: {
            env.aboutUs.toggle()
        }) {
            Image(systemName: "info.circle")
                .foregroundColor(.primaryDota)
        }, trailing: EditButton())
        .listStyle(SidebarListStyle())
        .overlay(VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {env.addNewAccount.toggle()}) {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .frame(width: 15, height: 15)
                        .padding(25)
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.primaryDota).shadow(radius: 5))
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }.padding())
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
