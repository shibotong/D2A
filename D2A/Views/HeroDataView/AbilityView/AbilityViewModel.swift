//
//  AbilityViewModel.swift
//  App
//
//  Created by Shibo Tong on 11/6/2022.
//

import Foundation
import Combine
import AVFoundation
import StratzAPI
import UIKit

class AbilityViewModel: ObservableObject {
    
    let heroID: Int
    
    // AbilityTitleView
    let displayName: String
    let cd: String?
    let mc: String?
    let name: String?
    
    // AbilityStatsView
    let behavior: String?
    let targetTeam: String?
    let bkbPierce: String?
    let dispellable: String?
    let damageType: String?
    
    // AbilityDescriptionView
    @Published var scepterVideo: AVPlayer?
    @Published var shardVideo: AVPlayer?
    @Published var abilityVideo: AVPlayer?
    
    let description: String?
    let scepter: String?
    let shard: String?
    
    let lore: String?
    let attributes: [AbilityTranslation.Attribute]?
    
    private var database = HeroDatabase.shared
    
    private var cancellables = Set<AnyCancellable>()
        
    convenience init(heroID: Int, ability: any AbilityProtocol) {
        self.init(heroID: heroID, displayName: ability.displayName ?? "", cd: ability.coolDown,
                  mc: ability.manaCost, name: ability.name, behavior: ability.behavior,
                  targetTeam: ability.targetTeam, bkbPierce: ability.bkbPierce, dispellable: ability.dispellable,
                  damageType: ability.damageType, description: ability.description, scepter: ability.scepter, shard: ability.shard,
                  lore: ability.lore, attributes: ability.attributes)
    }
    
    init(heroID: Int, displayName: String, cd: String?,
         mc: String?, name: String?, behavior: String?,
         targetTeam: String?, bkbPierce: String?, dispellable: String?,
         damageType: String?, scepterVideo: AVPlayer? = nil,
         shardVideo: AVPlayer? = nil, abilityVideo: AVPlayer? = nil,
         description: String?, scepter: String?, shard: String?,
         lore: String?, attributes: [AbilityTranslation.Attribute]?,
         database: HeroDatabase = HeroDatabase.shared,
         cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.heroID = heroID
        self.displayName = displayName
        self.cd = cd
        self.mc = mc
        self.name = name
        self.behavior = behavior
        self.targetTeam = targetTeam
        self.bkbPierce = bkbPierce
        self.dispellable = dispellable
        self.damageType = damageType
        self.scepterVideo = scepterVideo
        self.shardVideo = shardVideo
        self.abilityVideo = abilityVideo
        self.description = description
        self.scepter = scepter
        self.shard = shard
        self.lore = lore
        self.attributes = attributes
        self.database = database
        self.cancellables = cancellables
        
        Task {
            await buildDetailView()
        }
    }
    
    func buildDetailView() async {
        var ability: AVAsset?
        var scepter: AVAsset?
        var shard: AVAsset?
        guard let abilityName = name else { return }
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
        let baseURL = "\(IMAGE_PREFIX)/apps/dota2/videos/dota_react/abilities/\(heroName)"
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
