//
//  ProfileView.swift
//  App
//
//  Created by Shibo Tong on 3/9/21.
//

import SwiftUI

struct ProfileView: View {

    let userID: String
    let personaname: String
    let avatarfull: String
    let isFavourite: Bool
    
    init(profile: UserProfile) {
        userID = profile.userID.description
        personaname = profile.personaname ?? ""
        avatarfull = profile.avatarfull ?? ""
        isFavourite = profile.favourite
    }
    
    init(userID: String, personaname: String, avatarfull: String, isFavourite: Bool = false) {
        self.userID = userID
        self.personaname = personaname
        self.avatarfull = avatarfull
        self.isFavourite = isFavourite
    }

    private var avatar: some View {
        ProfileAvatar(
            userID: userID, imageURL: avatarfull, cornerRadius: 0)
        .clipShape(Circle())
    }

    var body: some View {
        HStack {
            avatar.frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(personaname).bold()
                Text("ID: \(userID)")
                    .foregroundColor(.secondaryLabel)
                    .font(.caption)
            }
            Spacer()
            if isFavourite {
                Image(systemName: "star.fill")
                    .foregroundColor(.primaryDota)
            }
        }
    }
}
