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
            if let profile = vm.profile, let personaname = profile.personaname, let userID = profile.id {
                HStack {
                    ProfileAvatar(profile: profile, cornerRadius: 5)
                        .frame(width: 40, height: 40)
                    VStack(alignment: .leading) {
                        Text(personaname).bold()
                        Text("ID: \(userID)")
                            .foregroundColor(.secondaryLabel)
                            .font(.caption)
                    }
                    Spacer()
                    if profile.register && profile.favourite {
                        Image(systemName: "person.text.rectangle")
                            .foregroundColor(.primaryDota)
                    } else if profile.favourite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.primaryDota)
                    }
                }
            } else {
                ProfileEmptyView()
            }
        } else {
            ProgressView()
                .frame(height: 40)
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
