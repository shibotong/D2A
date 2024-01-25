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
                                          userName: "D2A",
                                          image: UIImage(named: "profile")!,
                                          matches: previewMatches,
                                          isPlus: true,
                                          rank: 11,
                                          leaderboard: nil)
    
    init?(_ profile: UserProfile, image: UIImage?, matches: [RecentMatch]) {
        guard let userID = profile.id,
              let userName = profile.personaname else {
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
    
    private static var randomHeroID: Int {
        Int.random(in: 1..<100)
    }
    
    private static var randomWinLoss: Bool {
        return Int.random(in: 0...1) == 0
    }
    
    private static var previewMatches: [D2AWidgetMatch] {
        let matches = (1...10).map { id in
            D2AWidgetMatch(matchID: id.description, heroID: randomHeroID, win: randomWinLoss)
        }
        return  matches
    }
}
