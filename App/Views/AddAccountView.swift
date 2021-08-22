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
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color.primaryDota))
                    Button(action: {
                        vm.searched = true
                        vm.searchUserId = vm.userid
                    }) {
                        Text("Search").foregroundColor(.white).bold()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color.primaryDota))
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
                            // TODO: open user profile page
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
