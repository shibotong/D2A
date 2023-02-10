//
//  MatchListRowView.swift
//  App
//
//  Created by Shibo Tong on 27/8/21.
//

import SwiftUI

struct MatchListRowView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalClass
    
    var match: RecentMatch
    
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
                        if let startTime = match.startTime {
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
                    if let startTime = match.startTime {
                        Text(startTime.toTime).bold().foregroundColor(.secondaryLabel)
                            .frame(width: 70, alignment: .trailing)
                    }
                }.font(.body)
            }
        }
    }
    
    private var gameLobbyText: some View {
        Text(LocalizedStringKey(match.gameLobby.lobbyName))
            .foregroundColor(match.gameLobby.lobbyName == "Ranked" ? Color(.systemYellow) : Color(.secondaryLabel))
    }
    
    private var heroImage: some View {
        HeroImageView(heroID: Int(match.heroID), type: .icon)
            .frame(width: 30, height: 30)
    }
    
    private var kdaView: some View {
        KDAView(kills: Int(match.kills),
                deaths: Int(match.deaths),
                assists: Int(match.assists),
                size: isCompact ? .caption : .body)
    }
    
    private var gameMode: some View {
        Text(LocalizedStringKey(match.gameMode.modeName))
            .font(isCompact ? .caption2 : .body)
            .foregroundColor(.secondaryLabel)
    }
    
    var winLoss: some View {
        Rectangle().frame(width: 15, height: 15).foregroundColor(Color(match.playerWin ? .systemGreen : .systemRed))
            .overlay {
                Text(match.playerWin ? "W" : "L")
                    .foregroundColor(.white)
                    .font(.caption2)
            }
    }
    
    var body: some View {
        HStack {
            winLoss
            headingView
            Spacer()
            if let size = Int(match.partySize) {
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
            MatchListRowView(match: RecentMatch.example)
                .previewDevice(.iPad)
                .previewLayout(.fixed(width: 500, height: 70))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .previewDisplayName("iPad")
            MatchListRowView(match: RecentMatch.example)
                .previewDevice(.iPhone)
                .previewLayout(.fixed(width: 375, height: 70))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .previewDisplayName("iPhone")
        }
    }
}

struct MatchListRowEmptyView: View {
    @State var loading = false
    var body: some View {
        HStack {
            Rectangle().frame(width: 20).padding(.vertical, 1)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 25, height: 25)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 25)
                }
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 50, height: 20)
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 80, height: 20)
            }.padding(.vertical, 5)
            Spacer()
        }
        .foregroundColor(loading ? Color(.systemGray6) : Color(.systemGray5))
        .onAppear {
            loading = true
        }
        .animation(Animation.default.repeatForever(), value: loading)
    }
}
