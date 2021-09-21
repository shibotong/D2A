//
//  AddAccountView.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import SwiftUI
import SDWebImageSwiftUI

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
                        TextField("Dota2 ID", text: $vm.userid)
                            .keyboardType(.numberPad)
                            
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color.primaryDota))
                    Button(action: {
                        vm.searched = true
                        vm.searchUserId = vm.userid
                    }) {
                        Text("Search").foregroundColor(.white).bold()
                    }
                    .keyboardShortcut(.defaultAction)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color.primaryDota))
                }
//                HStack {
//                    Spacer()
//                    NavigationLink(destination: Text("Still Building....")) {
//                        Text("How to find my Dota2 ID?")
//                    }
//                }
                if vm.searched {
                    VStack {
                        ProfileView(vm: ProfileViewModel(id: vm.searchUserId), presentState: presentationMode).equatable()
                        Spacer()
                    }
                } else {
                    Spacer()
                }
            }
            
            .font(.custom(fontString, size: 15))
            .padding()
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


