//
//  MatchListRowViewV2.swift
//  D2A
//
//  Created by Shibo Tong on 4/11/2025.
//

import SwiftUI

struct MatchListRowViewV2: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    let heroID: Int
    let win: Bool
    let kill: Int
    let death: Int
    let assist: Int
    let partySize: Int?
    let mode: String
    let duration: String
    let isRadiant: Bool
    let isRank: Bool
    
    var body: some View {
        HStack {
            heroIcon
            WinLossView(win: win)
                .frame(width: 24, height: 24)
            HStack(spacing: 0) {
                kdaText(text: "\(kill)")
                Text("/")
                kdaText(text: "\(death)")
                Text("/")
                kdaText(text: "\(assist)")
            }
            .font(.subheadline)
            Spacer()
            isRankView
            partyView
            RankView(rank: 11)
                .frame(width: 48, height: 48)
            Divider()
            if horizontalSizeClass == .regular {
                teamView
                modeView
            }
            trailing
                .frame(width: 64)
        }
    }
    
    private var teamView: some View {
        Image(isRadiant ? "icon_radiant" : "icon_dire")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 28)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    private var modeView: some View {
            Text(mode)
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 100)
                        .opacity(0.1)
                )
                .frame(width: 100)
    }
    
    private var heroIcon: some View {
        HeroImageView(heroID: heroID, type: horizontalSizeClass == .compact ? .icon : .full)
            .frame(height: 32)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    private var trailing: some View {
        VStack(alignment: .trailing) {
            Text(duration)
            Text("2 yr ago")
        }
        .font(.caption2)
    }
    
    @ViewBuilder
    private var partyView: some View {
        if let partySize {
            if partySize >= 4 {
                HStack(spacing: 2) {
                    Image(systemName: "person.3.fill")
                    Text(partySize.description)
                }
                .foregroundColor(.label)
            } else if partySize >= 2 {
                HStack(spacing: 2) {
                    Image(systemName: "person.2.fill")
                    Text(partySize.description)
                }
                .foregroundColor(.secondaryLabel)
            } else {
                HStack(spacing: 2) {
                    Image(systemName: "person.fill")
                    Text(partySize.description)
                }
                .foregroundColor(.tertiaryLabel)
            }
        }
    }
    
    private var isRankView: some View {
        Image(systemName: isRank ? "chevron.compact.up.chevron.compact.down" : "minus")
    }
    
    @ViewBuilder
    private func kdaText(text: String) -> some View {
        Text(text)
            .bold()
            .lineLimit(1)
            .frame(width: 20)
    }
}

#Preview {
    MatchListRowViewV2(heroID: 1, win: true, kill: 10, death: 10, assist: 99, partySize: 3, mode: "All Pick", duration: "12:10", isRadiant: true, isRank: true)
        .environmentObject(EnvironmentController.preview)
        .environment(\.managedObjectContext, PersistanceProvider.preview.mainContext)
}
