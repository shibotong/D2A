//
//  D2AWidgetUser.swift
//  D2A
//
//  Created by Shibo Tong on 26/1/2024.
//

import UIKit

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
