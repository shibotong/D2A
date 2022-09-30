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
    var maxMatches: Int {
        switch self.family {
        case .systemSmall:
            return 1
        case .systemMedium:
            return 2
        case .systemLarge:
            return 5
        default:
            return 1
        }
    }
    var body: some View {
        ZStack {
            if entry.user.id == 0 {
                WidgetOverlayView(widgetType: .chooseProfile)
            } else {
                GeometryReader { proxy in
                    switch self.family {
                    case .systemSmall:
                        buildBody(cardHeight: proxy.size.height / 3)
                    case .systemMedium, .systemLarge:
                        let avatarHeight: CGFloat = 20
                        VStack(spacing: 5) {
                            Link(destination: URL(string: "d2aapp:profile?userid=\(entry.user.id)")!) {
                                HStack {
                                    NetworkImage(urlString: entry.user.avatarfull).frame(width: avatarHeight, height: avatarHeight).clipShape(Circle())
                                    Text("\(entry.user.personaname)").font(.caption2).bold()
                                    Spacer()
                                    Text("\(entry.user.id.description)")
                                        .font(.caption2)
                                        .foregroundColor(.secondaryLabel)
                                }
                            }
                            buildMatches(self.maxMatches, height: proxy.size.height - 40)
                        }.padding(10)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .blur(radius: entry.subscription ? 0 : 15)
        .overlay {
            if !entry.subscription {
                WidgetOverlayView(widgetType: .subscription)
            }
        }
    }
    
    @ViewBuilder func buildMatch(match: RecentMatch) -> some View {
        HStack {
            buildWL(win: match.isPlayerWin())
            VStack(alignment: .leading, spacing: 1) {
                HStack {
                    HeroImageView(heroID: match.heroID, type: .icon)
                        .frame(width: 25, height: 25)
                    VStack(alignment: .leading) {
                        KDAView(kills: match.kills, deaths: match.deaths, assists: match.assists, size: .caption)
                        Text(LocalizedStringKey(match.fetchMode().fetchModeName()))
                            .font(.caption2)
                    }
                }
            }
            if let size = match.partySize {
                buildParty(size: size)
            }
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(LocalizedStringKey(match.fetchLobby().lobbyName))
                        .foregroundColor(match.fetchLobby().lobbyName == "Ranked" ? Color(.systemYellow) : Color(.secondaryLabel))
                    Text(match.startTime.convertToTime()).bold()
                }
            }
            .font(.caption2)
            .foregroundColor(Color(.secondaryLabel))
            .frame(width: 70)
        }
    }
    
    @ViewBuilder func buildMatches(_ matchNumber: Int, height: CGFloat) -> some View {
        let matches = Array(entry.matches[0..<matchNumber])
        let rowHeight = height / CGFloat(matchNumber)
        VStack(spacing: 0) {
            ForEach(matches) { match in
                    Divider()
                    Link(destination: URL(string: "d2aapp:match?matchid=\(match.id)")!) {
                        buildMatch(match: match)
                            .padding(5)
                            .frame(height:rowHeight)
                    }
                    .disabled(!entry.subscription && entry.user.id != 0)
                
            }
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
                            KDAView(kills: match.kills, deaths: match.deaths, assists: match.assists, size: .caption)
                        }
                    }
                    HStack(spacing: 2) {
                        buildWL(win: match.isPlayerWin(), size: 15)
                        Text(LocalizedStringKey(match.fetchLobby().lobbyName))
                            .font(.caption)
                            .foregroundColor(match.fetchLobby().lobbyName == "Ranked" ? Color(.systemYellow) : Color(.secondaryLabel))
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
        LatestMatchWidgetEntryView(entry: SimpleEntry(date: Date(), matches: Array(RecentMatch.sample), user: UserProfile.sample, subscription: false))
//            .environment(\.widgetFamily, .systemSmall)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        LatestMatchWidgetEntryView(entry: SimpleEntry(date: Date(), matches: Array(RecentMatch.sample), user: UserProfile.sample, subscription: false))
//            .environment(\.widgetFamily, .systemMedium)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        LatestMatchWidgetEntryView(entry: SimpleEntry(date: Date(), matches: Array(RecentMatch.sample), user: UserProfile.sample, subscription: false))
//            .environment(\.widgetFamily, .systemLarge)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
//            .previewDevice(PreviewDevice.iPodTouch)
    }
}
