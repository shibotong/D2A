//
//  PlayerView.swift
//  D2A
//
//  Created by Shibo Tong on 20/9/2025.
//

import SwiftUI

struct PlayerView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var viewModel: ViewModel
    
    private var avatarSize: CGFloat {
        horizontalSizeClass == .regular ? 100 : 50
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
            RankView(rank: viewModel.rank, leaderboard: viewModel.leaderboard)
                .frame(width: avatarSize, height: avatarSize)
        }
    }
    
    private var name: some View {
        VStack(alignment: .leading) {
            Text(viewModel.name ?? viewModel.personaname)
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
            Text(viewModel.personaname)
                .font(.subheadline)
                .lineLimit(1)
        }
    }
    
    private var avatar: some View {
        ProfileAvatar(userID: "\(viewModel.userID)", imageURL: viewModel.imageURL, cornerRadius: 5)
    }
}

#Preview {
    PlayerView(viewModel: .init(userID: 153041957, personaname: "Mr.BOBOBO", name: "ST", isPlus: true, rank: 80, leaderboard: 100))
        .environmentObject(EnvironmentController.preview)
}
