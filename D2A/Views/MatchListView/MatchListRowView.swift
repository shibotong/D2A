//
//  MatchListRowView.swift
//  App
//
//  Created by Shibo Tong on 27/8/21.
//

import SwiftUI

struct MatchListRowView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalClass
    
    @ObservedObject var viewModel: MatchListRowViewModel
    
    private var isCompact: Bool {
        return horizontalClass == .compact || DotaEnvironment.isInWidget()
    }
    
    private var headingView: some View {
        Group {
            if isCompact {
                VStack(alignment: .leading, spacing: 1) {
                    HStack {
                        heroImage
                        VStack(alignment: .leading) {
                            kdaView
                            gameMode
                        }
                    }
                }.padding(.vertical)
            } else {
                heroImage
                kdaView
                    .frame(maxWidth: 150, alignment: .leading)
                gameMode
                    .frame(maxWidth: 100, alignment: .leading)
            }
        }
    }
    
    private var trailingView: some View {
        Group {
            if isCompact {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        gameLobbyText
                        if let startTime = viewModel.startTime {
                            Text(startTime.toTime).bold()
                        }
                    }
                }
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
                .frame(width: 70)
            } else {
                HStack {
                    gameLobbyText
                        .frame(width: 70, alignment: .leading)
                    if let startTime = viewModel.startTime {
                        Text(startTime.toTime).bold().foregroundColor(.secondaryLabel)
                            .frame(width: 100, alignment: .trailing)
                    }
                }.font(.body)
            }
        }
    }
    
    private var gameLobbyText: some View {
        Text(LocalizedStringKey(viewModel.gameLobby))
            .foregroundColor(viewModel.gameLobby == "Ranked" ? Color(.systemYellow) : Color(.secondaryLabel))
    }
    
    private var heroImage: some View {
        HeroImageView(heroID: Int(viewModel.heroID), type: .icon)
            .frame(width: 30, height: 30)
    }
    
    private var kdaView: some View {
        KDAView(kills: viewModel.kills,
                deaths: viewModel.deaths,
                assists: viewModel.assists,
                size: isCompact ? .caption : .body)
    }
    
    private var gameMode: some View {
        Text(LocalizedStringKey(viewModel.gameMode))
            .font(isCompact ? .caption2 : .body)
            .foregroundColor(.secondaryLabel)
    }
    
    var winLoss: some View {
        Rectangle().frame(width: 15, height: 15).foregroundColor(Color(viewModel.isWin ? .systemGreen : .systemRed))
            .overlay {
                Text(viewModel.isWin ? "W" : "L")
                    .foregroundColor(.white)
                    .font(.caption2)
            }
    }
    
    var body: some View {
        HStack {
            winLoss
            headingView
            Spacer()
            if let size = viewModel.partySize, size != 0 {
                buildParty(size: size)
                    .frame(alignment: .leading)
            }
            Spacer()
            trailingView
        }
        .padding(.horizontal)
        .frame(height: 70)
    }
    
    @ViewBuilder private func buildParty(size: Int) -> some View {
        if size >= 4 {
            HStack(spacing: 2) {
                Image(systemName: "person.3.fill")
                Text(size.description)
            }
            .font(.caption)
            .foregroundColor(.label)
        } else if size >= 2 {
            HStack(spacing: 2) {
                Image(systemName: "person.2.fill")
                Text(size.description)
            }
            .font(.caption)
            .foregroundColor(.secondaryLabel)
        } else {
            HStack(spacing: 2) {
                Image(systemName: "person.fill")
                Text(size.description)
            }
            .font(.caption)
            .foregroundColor(.tertiaryLabel)
        }
    }
}

struct MatchListRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MatchListRowView(
                viewModel: MatchListRowViewModel(
                    isWin: true,
                    heroID: 1,
                    kills: 10,
                    deaths: 10,
                    assists: 10,
                    partySize: 3,
                    gameMode: "All Pick",
                    lobbyName: "Ranked"))
                .previewDevice(.iPad)
                .previewLayout(.fixed(width: 800, height: 70))
                .environment(\.managedObjectContext, PersistanceController.preview.container.viewContext)
                .previewDisplayName("iPad")
            MatchListRowView(
                viewModel: MatchListRowViewModel(
                    isWin: true,
                    heroID: 1,
                    kills: 10,
                    deaths: 10,
                    assists: 10,
                    partySize: 3,
                    gameMode: "Ranked",
                    lobbyName: "Ranked"))
                .previewDevice(.iPhone)
                .previewLayout(.fixed(width: 375, height: 70))
                .environment(\.managedObjectContext, PersistanceController.preview.container.viewContext)
                .previewDisplayName("iPhone")
        }
    }
}
