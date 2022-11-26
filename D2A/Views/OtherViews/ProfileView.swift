//
//  ProfileView.swift
//  App
//
//  Created by Shibo Tong on 3/9/21.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var env: DotaEnvironment
    @ObservedObject var vm: ProfileViewModel
    
    var body: some View {
        if !vm.isloading {
            if let personaname = vm.personaname {
                HStack {
                    ProfileAvartar(image: vm.profileIcon, sideLength: 40, cornerRadius: 5)
                    VStack(alignment: .leading) {
                        Text(personaname).bold()
                        Text("ID: \(vm.userid.description)")
                            .foregroundColor(.secondaryLabel)
                            .font(.caption)
                    }
                    Spacer()
                    if vm.userid.description == env.registerdID {
                        Image(systemName: "person.text.rectangle")
                            .foregroundColor(.primaryDota)
                    }
                    if env.userIDs.contains(vm.userid.description) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.primaryDota)
                    }
                }
            } else {
                ProfileEmptyView()
            }
        } else {
            ProgressView()
        }
    }
}

struct ProfileEmptyView: View {
    var body: some View {
        HStack {
            Image("profile")
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius:5))
            VStack(alignment: .leading) {
                Text("Anonymous").bold()
                Text(" ").font(.caption)
            }
            Spacer()
        }
    }
}
