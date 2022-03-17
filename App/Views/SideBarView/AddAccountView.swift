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
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Dota2 ID or username", text: $vm.userid)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color.primaryDota))
                    Button(action: {
                        Task {
                            await vm.search()
                        }
                    }) {
                        Text("Search").foregroundColor(.white).bold()
                    }
                    .keyboardShortcut(.defaultAction)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color.primaryDota))
                }.padding(.horizontal)
                if vm.searched {
                    List(vm.userProfiles) { profile in 
                        ProfileView(vm: ProfileViewModel(profile: profile), presentState: presentationMode).equatable()
                    }.listStyle(.plain)
                } else {
                    Spacer()
                }
            }
            
            .font(.custom(fontString, size: 15))
            .padding(.vertical)
            .navigationTitle("Search Dota2 Profile")
        }
    }
    
    static func == (lhs: AddAccountView, rhs: AddAccountView) -> Bool {
        return true
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountView()
            .environmentObject(DotaEnvironment.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}


