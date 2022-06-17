//
//  LatestMatchWidgetEntryView.swift
//  App
//
//  Created by Shibo Tong on 17/6/2022.
//

import SwiftUI
import WidgetKit

struct LatestMatchWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    var body: some View {
        GeometryReader { proxy in
            buildBody(cardHeight: proxy.size.height / 3)
        }
    }
    
    @ViewBuilder
    private func buildBody(cardHeight: CGFloat) -> some View {
        let match = entry.matches.first!
        let user = entry.user
        let avatarSize: CGFloat = cardHeight - 5
        let iconSize: CGFloat = cardHeight / 3
        VStack {
            VStack {
                NetworkImage(urlString: user.avatarfull)
                    .frame(width: avatarSize, height: avatarSize)
                    .clipShape(Circle())
                Text(user.personaname)
                    .lineLimit(1)
                    .font(.caption)
            }
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius:10).foregroundColor(.secondarySystemBackground).shadow(radius: 3)
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 1) {
                        HeroImageView(heroID: match.heroID, type: .icon)
                            .frame(width: iconSize, height: iconSize)
                        VStack(alignment: .leading) {
                            KDAView(kills: match.kills, deaths: match.deaths, assists: match.assists, size: 12)
                        }
                    }
                    HStack(spacing: 2) {
                        buildWL(win: match.isPlayerWin(), size: 15)
                        Text(LocalizedStringKey(match.fetchLobby().fetchLobbyName()))
                            .font(.caption)
                            .foregroundColor(match.fetchLobby().fetchLobbyName() == "Ranked" ? Color(.systemYellow) : Color(.secondaryLabel))
                        Text(match.startTime.convertToTime()).font(.caption)
                            .foregroundColor(.secondaryLabel)
                    }
                }.padding(5)
            }.frame(height: cardHeight)
        }
        .padding(10)
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
    
    @ViewBuilder private func buildWL(win: Bool, size: CGFloat = 15) -> some View {
        ZStack {
            Rectangle().foregroundColor(win ? Color(.systemGreen) : Color(.systemRed))
                .frame(width: size, height: size)
            Text("\(win ? "W" : "L")").font(.caption).bold().foregroundColor(.white)
        }
    }
}

struct LatestMatchWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LatestMatchWidgetEntryView(entry: SimpleEntry(date: Date(), matches: Array(RecentMatch.sample), user: UserProfile.sample, subscription: true))
            .environment(\.widgetFamily, .systemSmall)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        LatestMatchWidgetEntryView(entry: SimpleEntry(date: Date(), matches: Array(RecentMatch.sample), user: UserProfile.sample, subscription: true))
            .environment(\.widgetFamily, .systemSmall)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDevice(iPodTouch)
    }
}
