//
//  BanPick.swift
//  D2A
//
//  Created by Shibo Tong on 24/10/2022.
//

import Foundation

struct BanPick: Identifiable {
    var id = UUID()
    var heroID: Int = 0
    var isPick: Bool
    var isRadiant: Bool
    var order: Int
    
    init(from pickBan: MatchLiveHistoryQuery.Data.Live.Match.PlaybackDatum.PickBan) {
        if let pickedHeroID = pickBan.heroId {
            heroID = Int(pickedHeroID)
        }
        if let bannedHeroID = pickBan.bannedHeroId {
            heroID = Int(bannedHeroID)
        }
        isPick = pickBan.isPick
        isRadiant = pickBan.isRadiant ?? true
        order = pickBan.order ?? 0
    }
    
    init(from pickBan: MatchLiveSubscription.Data.MatchLive.PlaybackDatum.PickBan) {
        if let pickedHeroID = pickBan.heroId {
            heroID = Int(pickedHeroID)
        }
        if let bannedHeroID = pickBan.bannedHeroId {
            heroID = Int(bannedHeroID)
        }
        isPick = pickBan.isPick
        isRadiant = pickBan.isRadiant ?? true
        order = pickBan.order ?? 0
    }
}
