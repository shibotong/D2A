//
//  PlayerView.swift
//  D2A
//
//  Created by Shibo Tong on 20/9/2025.
//

import SwiftUI

struct PlayerView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    let viewModel: UserProfile
    
    private var avatarSize: CGFloat {
        horizontalSizeClass == .regular ? 64 : 32
    }
    
    var body: some View {
        HStack(spacing: 16) {
            if horizontalSizeClass == .regular {
                avatar
                    .frame(width: avatarSize, height: avatarSize)
            }
            name
            Spacer()
            if viewModel.isPlus {
                Image("dota_plus")
                    .resizable()
                    .padding(avatarSize / 10)
                    .frame(width: avatarSize, height: avatarSize)
            }
            RankView(rank: Int(viewModel.rank), leaderboard: Int(viewModel.leaderboard))
                .frame(width: avatarSize, height: avatarSize)
        }
    }
    
    private var name: some View {
        VStack(alignment: .leading) {
            Text((viewModel.name ?? viewModel.personaname) ?? "")
                .font(horizontalSizeClass == .regular ? .largeTitle : .body)
                .bold()
                .lineLimit(1)
            if viewModel.name != nil {
                subNameBar
            }
        }
    }
    
    @ViewBuilder
    private var subNameBar: some View {
        if viewModel.name != nil {
            Text(viewModel.personaname ?? "")
                .font(.subheadline)
                .lineLimit(1)
        }
    }
    
    private var avatar: some View {
        ProfileAvatar(userID: "\(viewModel.userID)", imageURL: viewModel.avatarfull, cornerRadius: 5)
    }
}

#Preview {
    let user = UserProfile()
    user.userID = 153041957
    user.personaname = "Mr.BOBOBO"
    user.name = "ST"
    user.avatarfull = "h"
    user.rank = 80
    user.leaderboard = 100
    user.isPlus = true
    user.countryCode = "AU"
    return PlayerView(viewModel: user)
        .environmentObject(EnvironmentController.preview)
}
