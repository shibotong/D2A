//
//  D2AWidget.swift
//  D2AWidget
//
//  Created by Shibo Tong on 18/9/21.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct D2AWidget: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        RecentMatchesWidget()
        LatestMatchWidget()
        
        if #available(iOS 16.1, *) {
            LiveMatchActivityWidget()
        }
    }
}

struct RecentMatchesWidget: Widget {
    let kind: String = "D2AWidget"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicUserSelectionIntent.self, provider: Provider()) { entry in
            RecentMatchesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Recent Matches")
        .description("Your recent matches.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .containerBackgroundRemovable(true)
    }
}

struct LatestMatchWidget: Widget {
    let kind: String = "LatestWidget"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicUserSelectionIntent.self, provider: Provider()) { entry in
            LatestMatchWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Latest Match")
        .description("Your latest match.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .containerBackgroundRemovable(true)
        
    }
}

struct D2AWidgetUserEntry: TimelineEntry {
    let date: Date
    let user: D2AWidgetUser?
    let subscription: Bool
    
    static let preview = D2AWidgetUserEntry(date: Date(), user: D2AWidgetUser.preview, subscription: true)
}

struct D2AWidgetUser {
    let userID: String
    let userName: String
    let image: UIImage
    let matches: [D2AWidgetMatch]
    let isPlus: Bool
    let rank: Int?
    let leaderboard: Int?
    
    static let preview = D2AWidgetUser(userID: "1234567",
                                          userName: "Test User",
                                          image: UIImage(named: "profile")!,
                                          matches: [
                                            .init(matchID: "1", heroID: 1, win: true),
                                            .init(matchID: "2", heroID: 2, win: false),
                                            .init(matchID: "3", heroID: 1, win: true),
                                            .init(matchID: "4", heroID: 2, win: false),
                                            .init(matchID: "5", heroID: 1, win: true),
                                            .init(matchID: "6", heroID: 2, win: false),
                                            .init(matchID: "7", heroID: 1, win: true),
                                            .init(matchID: "8", heroID: 2, win: false),
                                            .init(matchID: "9", heroID: 1, win: true),
                                            .init(matchID: "10", heroID: 2, win: false),
                                            .init(matchID: "11", heroID: 1, win: true),
                                            .init(matchID: "12", heroID: 2, win: false),
                                            .init(matchID: "13", heroID: 1, win: true)
                                          ],
                                          isPlus: true,
                                          rank: 11,
                                          leaderboard: nil)
    
    init?(_ profile: UserProfile, image: UIImage?, matches: [RecentMatch]) {
        guard let userID = profile.id,
              let userName = profile.name else {
                  return nil
              }        
        let widgetMatches = matches.map { D2AWidgetMatch($0) }
        self.init(userID: userID, userName: userName,
                  image: image ?? UIImage(named: "profile")!, matches: widgetMatches,
                  isPlus: profile.isPlus, rank: Int(profile.rank),
                  leaderboard: Int(profile.leaderboard))
    }
    
    init(userID: String, userName: String, image: UIImage, matches: [D2AWidgetMatch], isPlus: Bool, rank: Int?, leaderboard: Int?) {
        self.userID = userID
        self.userName = userName
        self.image = image
        self.matches = matches
        self.isPlus = isPlus
        self.rank = rank
        self.leaderboard = leaderboard
    }
}

struct D2AWidgetMatch: Identifiable {
    let id: String
    let heroID: Int
    let win: Bool
    
    let kills: Int
    let deaths: Int
    let assists: Int
    
    let startTime: Date?
    let lobby: LobbyType
    
    init(_ match: RecentMatch) {
        self.init(matchID: match.id ?? "0",
                  heroID: Int(match.heroID),
                  win: match.playerWin,
                  kills: Int(match.kills),
                  deaths: Int(match.deaths),
                  assists: Int(match.assists),
                  startTime: match.startTime,
                  lobby: match.gameLobby)
    }
    
    init(matchID: String,
         heroID: Int,
         win: Bool,
         kills: Int = 0,
         deaths: Int = 0,
         assists: Int = 0,
         startTime: Date? = nil,
         lobby: LobbyType = .init(id: 1, name: "lobby")) {
        id = matchID
        self.heroID = heroID
        self.win = win
        self.kills = kills
        self.deaths = deaths
        self.assists = assists
        self.startTime = startTime
        self.lobby = lobby
    }
}
