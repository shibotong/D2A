//
//  AbilityViewModel.swift
//  App
//
//  Created by Shibo Tong on 11/6/2022.
//

import Foundation
import AVFoundation
import StratzAPI

class AbilityViewModel: ObservableObject, Equatable {
    static func == (lhs: AbilityViewModel, rhs: AbilityViewModel) -> Bool {
        return lhs.heroID == rhs.heroID && lhs.abilityName == rhs.abilityName
    }
    
    let heroID: Int
    
    @Published var stratzAbility: AbilityQuery.Data.Constants.Ability?
    @Published var opentDotaAbility: Ability?
    
    @Published var scepterVideo: AVPlayer?
    @Published var shardVideo: AVPlayer?
    @Published var abilityVideo: AVPlayer?
    
    private var database = HeroDatabase.shared
    private var abilityName: String
        
    init(heroID: Int, abilityName: String) {
        stratzAbility = database.fetchStratzAbility(name: abilityName)
        opentDotaAbility = database.fetchOpenDotaAbility(name: abilityName)
        self.heroID = heroID
        self.abilityName = abilityName
        Task {
            await buildDetailView()
        }
    }
    
    func buildDetailView() async {
        var ability: AVAsset?
        var scepter: AVAsset?
        var shard: AVAsset?
        if abilityVideo == nil {
            ability = getVideoURL(abilityName, type: .non)
        }
        if scepterVideo == nil {
            scepter = getVideoURL(abilityName, type: .scepter)
        }
        if shardVideo == nil {
            shard = getVideoURL(abilityName, type: .shard)
        }
        await setVideoURL(ability: ability, scepter: scepter, shard: shard)
    }
    
    @MainActor
    private func setVideoURL(ability: AVAsset?, scepter: AVAsset?, shard: AVAsset?) {
        if let ability {
            let player = AVPlayer(playerItem: AVPlayerItem(asset: ability))
            player.isMuted = true
            abilityVideo = player
        }
        if let scepter {
            let player = AVPlayer(playerItem: AVPlayerItem(asset: scepter))
            player.isMuted = true
            scepterVideo = player
        }
        if let shard {
            let player = AVPlayer(playerItem: AVPlayerItem(asset: shard))
            player.isMuted = true
            shardVideo = player
        }
    }
    
    private func getVideoURL(_ ability: String, type: ScepterType) -> AVAsset? {
        guard let heroName = try? database.fetchHeroWithID(id: heroID).name.replacingOccurrences(of: "npc_dota_hero_", with: "") else {
            return nil
        }
        let baseURL = "https://cdn.cloudflare.steamstatic.com/apps/dota2/videos/dota_react/abilities/\(heroName)"
        var path = ""
        switch type {
        case .scepter:
            path = "\(baseURL)/\(heroName)_aghanims_scepter.mp4"
        case .shard:
            path = "\(baseURL)/\(heroName)_aghanims_shard.mp4"
        case .non:
            path = "\(baseURL)/\(ability).mp4"
        }

        guard let video = CacheVideo.shared.getVideo(key: path, heroID: heroID) else {
            return nil
        }
        return video.isPlayable ? video: nil
    }
}

private class CacheVideo {
    private var cache = NSCache<NSString, AVAsset>()
    private var currentHeroID: Int?

    static let shared = CacheVideo()
    
    func saveVideo(_ video: AVAsset, key: String, heroID: Int) {
        if heroID != currentHeroID {
            currentHeroID = heroID
            cache = NSCache<NSString, AVAsset>()
        }
        cache.setObject(video, forKey: key as NSString)
    }
    
    func getVideo(key: String, heroID: Int) -> AVAsset? {
        if let cacheVideo = cache.object(forKey: key as NSString) {
            return cacheVideo
        } else {
            guard let url = URL(string: key) else { return nil }
            let asset = AVAsset(url: url)
            saveVideo(asset, key: key, heroID: heroID)
            return asset
        }
    }
}
