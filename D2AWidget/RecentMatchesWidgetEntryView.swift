//
//  RecentMatchesWidgetEntryView.swift
//  App
//
//  Created by Shibo Tong on 17/6/2022.
//

import SwiftUI
import WidgetKit

struct RecentMatchesWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    private var maxNumberOfMatches: Int {
        switch self.family {
        case .systemSmall:
            return 5
        case .systemMedium:
            return 10
        default:
            return 5
        }
    }

    var body: some View {
        ZStack {
            mainBody
                .blur(radius: entry.subscription ? 0 : 15)
            if !entry.subscription {
                WidgetOverlayView(widgetType: .subscription)
            }
        }
        .widgetBackground(avatarBlurBackground)
    }

    private var mainBody: some View {
        ZStack {
            if let user = entry.user {
                GeometryReader { proxy in
                    VStack {
                        UserTitleView(
                            userName: user.userName,
                            userID: user.userID,
                            image: user.image,
                            isPlus: user.isPlus,
                            rank: user.rank,
                            leaderboard: user.leaderboard
                        )
                        .frame(height: proxy.size.height / 2)
                        matchView
                    }
                }
            } else {
                WidgetOverlayView(widgetType: .chooseProfile)
            }
        }
    }

    private var matches: [D2AWidgetMatch] {
        guard let totalMatches = entry.user?.matches else {
            return []
        }
        if totalMatches.count <= maxNumberOfMatches {
            return totalMatches
        } else {
            return Array(totalMatches[0..<maxNumberOfMatches])
        }
    }

    private var matchView: some View {
        HStack(alignment: .center, spacing: 3) {
            ForEach(matches) { match in
                RecentMatchWinLossView(
                    heroID: match.heroID,
                    playerWin: match.win)
            }
        }
    }

    private var avatarBlurBackground: some View {
        ZStack {
            if let image = entry.user?.image {
                Image(uiImage: image)
                    .clipShape(Circle())
                    .blur(radius: 20)
            }
            Color.systemBackground.opacity(0.7)

        }
    }
}

struct UserTitleView: View {

    let userName: String
    let userID: String
    let image: UIImage?
    let isPlus: Bool
    let rank: Int?
    let leaderboard: Int?

    @Environment(\.widgetFamily) private var family

    init(
        userName: String, userID: String, image: UIImage?, isPlus: Bool = false, rank: Int? = nil,
        leaderboard: Int? = nil
    ) {
        self.userName = userName
        self.userID = userID
        self.image = image
        self.isPlus = isPlus
        self.rank = rank
        self.leaderboard = leaderboard
    }

    var body: some View {
        switch family {
        case .systemSmall:
            smallView
        case .systemMedium:
            mediumView
        default:
            EmptyView()
        }
    }

    private var smallView: some View {
        VStack {
            userImage
                .clipShape(Circle())
            Text(userName)
                .font(.caption)
        }
    }

    private var mediumView: some View {
        HStack {
            userImage
                .clipShape(Circle())
                .padding(.vertical, 5)
            VStack(alignment: .leading) {
                Text(userName)
                    .font(.caption)
                Text(userID)
                    .font(.caption2)
                    .foregroundColor(.secondaryLabel)
            }

            Spacer()
            rankView
        }
    }

    private var userImage: some View {
        Image(uiImage: image ?? UIImage(named: "profile")!)
            .resizable()
            .scaledToFit()
    }

    private var rankView: some View {
        HStack {
            if isPlus {
                Image("dota_plus")
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical, 5)
            }
            RankView(rank: rank, leaderboard: leaderboard)
                .scaledToFit()
                .padding(.top, 5)
        }
    }
}

struct RecentMatchesWidgetEntryView_Previews: PreviewProvider {

    static let supportedFamilies: [WidgetFamily] = [.systemSmall, .systemMedium]

    static var previews: some View {
        ForEach(supportedFamilies, id: \.rawValue) { family in
            RecentMatchesWidgetEntryView(
                entry: D2AWidgetUserEntry(
                    date: Date(),
                    user: D2AWidgetUser.preview,
                    subscription: true)
            )
            //            .environment(\.widgetFamily, family)
            .previewContext(WidgetPreviewContext(family: family))
            .previewDisplayName(family.description)
        }
    }
}
