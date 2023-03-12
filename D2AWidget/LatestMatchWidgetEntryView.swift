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
            if let user = entry.user {
                GeometryReader { proxy in
                    switch family {
                    case .systemSmall:
                        buildBody(user: user, cardHeight: proxy.size.height / 3)
                    case .systemMedium, .systemLarge:
                        let avatarHeight: CGFloat = 20
                        VStack(spacing: 5) {
                            Link(destination: URL(string: "d2aapp:profile?userid=\(user.id ?? "0")")!) {
                                HStack {
                                    NetworkImage(profile: user)
                                        .frame(width: avatarHeight, height: avatarHeight)
                                        .clipShape(Circle())
                                    Text("\(user.personaname ?? "")").font(.caption2).bold()
                                    Spacer()
                                    Text("\(user.id ?? "")")
                                        .font(.caption2)
                                        .foregroundColor(.secondaryLabel)
                                }.padding([.top, .horizontal], 10)
                            }
                            buildMatches(maxMatches, height: proxy.size.height - 35)
                        }
                    default:
                        EmptyView()
                    }
                }
            } else {
                WidgetOverlayView(widgetType: .chooseProfile)
            }
        }
        .blur(radius: entry.subscription ? 0 : 15)
        .overlay {
            if !entry.subscription {
                WidgetOverlayView(widgetType: .subscription)
            }
        }
    }
    
    @ViewBuilder func buildMatches(_ matchNumber: Int, height: CGFloat) -> some View {
        let matches: [RecentMatch] = entry.matches.count >= matchNumber
                                     ? Array(entry.matches[0..<matchNumber])
                                     : entry.matches
        
        let rowHeight = height / CGFloat(matchNumber)
        VStack(spacing: 0) {
            ForEach(matches) { match in
                Divider()
                Link(destination: URL(string: "d2aapp:match?matchid=\(match.id!)")!) {
                    MatchListRowView(viewModel: MatchListRowViewModel(match: match))
                }
                .frame(height: rowHeight)
                .disabled(!entry.subscription && entry.user != nil)
            }
        }
    }
    
    @ViewBuilder
    private func buildBody(user: UserProfile, cardHeight: CGFloat) -> some View {
        let match = entry.matches.first!
        let avatarSize: CGFloat = cardHeight - 5
        let iconSize: CGFloat = cardHeight / 3
        VStack {
            VStack {
                NetworkImage(profile: user)
                    .frame(width: avatarSize, height: avatarSize)
                    .clipShape(Circle())
                Text(user.personaname ?? "")
                    .lineLimit(1)
                    .font(.caption)
            }
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 10).foregroundColor(.secondarySystemBackground).shadow(radius: 3)
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 1) {
                        HeroImageView(heroID: Int(match.heroID), type: .icon)
                            .frame(width: iconSize, height: iconSize)
                        VStack(alignment: .leading) {
                            KDAView(kills: Int(match.kills), deaths: Int(match.deaths), assists: Int(match.assists), size: .caption)
                        }
                    }
                    HStack(spacing: 2) {
                        WinLossView(win: match.playerWin)
                        Text(LocalizedStringKey(match.gameLobby.lobbyName))
                            .font(.caption)
                            .foregroundColor(match.gameLobby.lobbyName == "Ranked" ? Color(.systemYellow) : Color(.secondaryLabel))
                        Text(match.startTime?.toTime ?? Date().toTime).font(.caption)
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
}

struct LatestMatchWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LatestMatchWidgetEntryView(entry: SimpleEntry(date: Date(), matches: [], user: nil, subscription: false))
//            .environment(\.widgetFamily, .systemSmall)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        LatestMatchWidgetEntryView(entry: SimpleEntry(date: Date(), matches: [], user: nil, subscription: false))
//            .environment(\.widgetFamily, .systemMedium)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        LatestMatchWidgetEntryView(entry: SimpleEntry(date: Date(), matches: [], user: nil, subscription: false))
//            .environment(\.widgetFamily, .systemLarge)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
//            .previewDevice(PreviewDevice.iPodTouch)
    }
}
