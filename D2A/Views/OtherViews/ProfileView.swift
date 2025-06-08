//
//  ProfileView.swift
//  App
//
//  Created by Shibo Tong on 3/9/21.
//

import SwiftUI

struct ProfileView: View {
  @ObservedObject var viewModel: ProfileViewModel

  private var avatar: some View {
    ProfileAvatar(
      userID: viewModel.userID, imageURL: viewModel.avatarfull, cornerRadius: 0,
      profile: viewModel.profile)
  }

  var body: some View {
    HStack {
      avatar.frame(width: 40, height: 40)
      VStack(alignment: .leading) {
        Text(viewModel.personaname).bold()
        Text("ID: \(viewModel.userID)")
          .foregroundColor(.secondaryLabel)
          .font(.caption)
      }
      Spacer()
      if let profile = viewModel.profile {
        if profile.register && profile.favourite {
          Image(systemName: "person.text.rectangle")
            .foregroundColor(.primaryDota)
        } else if profile.favourite {
          Image(systemName: "star.fill")
            .foregroundColor(.primaryDota)
        }
      }
    }
  }
}
