//
//  ProfileView.swift
//  App
//
//  Created by Shibo Tong on 3/9/21.
//

import SwiftUI
import SDWebImageSwiftUI

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
                HStack {
                    WebImage(url: URL(string: vm.steamProfile!.profile.avatarfull))
                        .resizable()
                        .renderingMode(.original)
                        .indicator(.activity)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    VStack(alignment: .leading) {
                        Text("\(vm.steamProfile!.profile.personaname)").font(.custom(fontString, size: 20)).bold()
                        Text(vm.steamProfile!.profile.countryCode ?? "Unknown Country").font(.custom(fontString, size: 13))
                    }
                    Spacer()
                    Button(action: {
                        if selectedUser == nil {
                            selectedUser = "\(vm.steamProfile!.profile.id)"
                        }
                        env.addUser(userid: "\(vm.steamProfile!.profile.id)")
                    }) {
                        Image(systemName: env.userIDs.contains("\(vm.steamProfile!.profile.id)") ? "star.fill" :"star")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(env.userIDs.contains("\(vm.steamProfile!.profile.id)") ? .secondaryDota : .primaryDota))
                    }
                }
            }
        }
    }
    static func == (lhs: ProfileView, rhs: ProfileView) -> Bool {
        return lhs.vm.userid == rhs.vm.userid
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(vm: ProfileViewModel())
            .environmentObject(DotaEnvironment.shared)
    }
}
