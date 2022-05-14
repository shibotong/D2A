//
//  AddAccountView.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import SwiftUI

struct AddAccountView: View, Equatable {
    @EnvironmentObject var env: DotaEnvironment
    @ObservedObject var vm: AddAccountViewModel = AddAccountViewModel()
    @State private var showError = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            List(vm.userProfiles) { profile in
                ProfileView(vm: ProfileViewModel(profile: profile), presentState: presentationMode).equatable()
            }
            .listStyle(.plain)
            .font(.custom(fontString, size: 15))
            .navigationTitle("Search")
            .searchable(text: $vm.userid)
            .onSubmit(of: .search) {
                Task {
                    await vm.search()
                }
            }
        }
        
    }
    
    static func == (lhs: AddAccountView, rhs: AddAccountView) -> Bool {
        return true
    }
    
    @ViewBuilder func buildView() -> some View {
        if vm.searched {
            List(vm.userProfiles) { profile in
                ProfileView(vm: ProfileViewModel(profile: profile), presentState: presentationMode).equatable()
            }.listStyle(.plain)
        } else {
            Spacer()
        }
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountView()
            .environmentObject(DotaEnvironment.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}


