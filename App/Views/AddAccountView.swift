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
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Please Enter Dota2 ID", text: $vm.userid)
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
                HStack {
                    Spacer()
                    NavigationLink(destination: Text("Still Building....")) {
                        Text("How to find my Dota2 ID?")
                    }
                }
                if vm.searched {
                    ProfileView(vm: ProfileViewModel(id: vm.searchUserId)).equatable()
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
    }
}

struct ProfileView: View, Equatable {
    @EnvironmentObject var env: DotaEnvironment
    @ObservedObject var vm: ProfileViewModel
    @AppStorage("selectedUser") var selectedUser: String?
    
    var body: some View {
        if vm.isloading {
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        } else {
            if vm.steamProfile == nil {
                VStack {
                    Spacer()
                    Text("Cannot find user profile.")
                    Spacer()
                }
            }
            else {
                VStack {
                    Spacer()
                    WebImage(url: URL(string: vm.steamProfile!.profile.avatarfull))
                        .resizable()
                        .renderingMode(.original)
                        .indicator(.activity)
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    Text("\(vm.steamProfile!.profile.personaname)").font(.custom(fontString, size: 30)).bold()
                    Text(vm.steamProfile!.profile.countryCode ?? "Unknown Country").font(.custom(fontString, size: 20))
                    HStack {
                        Button(action: {
                            if let url = URL(string: vm.steamProfile!.profile.profileurl) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text("Profile").font(.custom(fontString, size: 15)).bold().foregroundColor(.primaryDota)
                                Spacer()
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).stroke().foregroundColor(.primaryDota))
                            
                        }
                        Button(action: {
                            if selectedUser == nil {
                                selectedUser = "\(vm.steamProfile!.profile.id)"
                            }
                            env.addUser(userid: "\(vm.steamProfile!.profile.id)")
                        }) {
                            HStack {
                                Spacer()
                                Text(env.userIDs.contains("\(vm.steamProfile!.profile.id)") ? "Followed" : "Follow").font(.custom(fontString, size: 15)).bold().foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(env.userIDs.contains("\(vm.steamProfile!.profile.id)") ? .secondaryDota : .primaryDota))
                        }
                    }
                    Spacer()
                }.padding()
            }
        }
    }
    static func == (lhs: ProfileView, rhs: ProfileView) -> Bool {
        return lhs.vm.userid == rhs.vm.userid
    }
}
