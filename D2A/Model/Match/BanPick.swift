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
    
    static let preview = {
        var picked: [BanPick] = []
        for i in 1...5 {
            picked.append(BanPick(heroID: i, isRadiant: true, isPicked: true))
        }
        
        for i in 6...10 {
            picked.append(BanPick(heroID: i, isRadiant: false, isPicked: true))
        }
        
        for i in 11...17 {
            picked.append(BanPick(heroID: i, isRadiant: true, isPicked: false))
        }
        
        for i in 18...25 {
            picked.append(BanPick(heroID: i, isRadiant: false, isPicked: false))
        }
        
        return picked
    }()
    
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
    
    /// This init is for testing purpose
    init(heroID: Int, isRadiant: Bool, isPicked: Bool) {
        self.heroID = heroID
        self.isRadiant = isRadiant
        self.isPick = isPicked
        self.order = 1
    }
}
