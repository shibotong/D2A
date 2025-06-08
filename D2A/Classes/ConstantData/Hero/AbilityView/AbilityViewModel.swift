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
    @Published var displayName: String = ""
    @Published var cd: String?
    @Published var mc: String?
    @Published var abilityImageURL: String?
    @Published var abilityID: String?
    
    // AbilityStatsView
    @Published var behavior: String?
    @Published var targetTeam: String?
    @Published var bkbPierce: String?
    @Published var dispellable: String?
    @Published var damageType: String?
    
    // AbilityDescriptionView
    @Published var scepterVideo: AVPlayer?
    @Published var shardVideo: AVPlayer?
    @Published var abilityVideo: AVPlayer?
    
    @Published var lore: String?
    
    // Ability Data
    @Published var stratzAbility: StratzAbility?
    @Published var opentDotaAbility: ODAbility?
    
    private var database = ConstantProvider.shared
    
    private var cancellables = Set<AnyCancellable>()
        
    init(heroID: Int, ability: ODAbility?) {
        self.heroID = heroID
        self.opentDotaAbility = ability
        setupBinding()
        if let abilityName = ability?.name {
            stratzAbility = database.fetchStratzAbility(name: abilityName)
        }
        
        Task {
            await buildDetailView()
        }
    }
    
    init(scepter: String, shard: String, ability: String) {
        heroID = 0
        guard let scepterURL = URL(string: scepter),
              let shardURL = URL(string: shard),
              let abilityURL = URL(string: ability) else {
            return
        }
        scepterVideo = AVPlayer(playerItem: AVPlayerItem(asset: AVAsset(url: scepterURL)))
        shardVideo = AVPlayer(playerItem: AVPlayerItem(asset: AVAsset(url: shardURL)))
        abilityVideo = AVPlayer(playerItem: AVPlayerItem(asset: AVAsset(url: abilityURL)))
        database = ConstantProvider.preview
    }
    
    private func setupBinding() {
        $stratzAbility
            .sink(receiveValue: { [weak self] ability in
                self?.displayName = ability?.language?.displayName ?? ""
                self?.lore = ability?.language?.lore
            })
            .store(in: &cancellables)
        
        $opentDotaAbility
            .sink { [weak self] ability in
                // AbilityTitleView
                self?.cd = ability?.coolDown?.transformString()
                self?.mc = ability?.manaCost?.transformString()
                
                self?.abilityID = ability?.name ?? ""
                guard let parsedImageURL = ability?
                    .img?
                    .replacingOccurrences(of: "_md", with: "")
                    .replacingOccurrences(of: "images/abilities",
                                          with: "images/dota_react/abilities") else {
                    return
                }
                let urlString = "\(IMAGE_PREFIX)\(parsedImageURL)"
                self?.abilityImageURL = urlString
                
                // AbilityStatsView
                self?.behavior = ability?.behavior?.transformString()
                self?.targetTeam = ability?.targetTeam?.transformString()
                self?.bkbPierce = ability?.bkbPierce?.transformString()
                self?.dispellable = ability?.dispellable?.transformString()
                self?.damageType = ability?.damageType?.transformString()
            }
            .store(in: &cancellables)
    }
    
    func buildDetailView() async {
        var ability: AVAsset?
        var scepter: AVAsset?
        var shard: AVAsset?
        guard let abilityName = opentDotaAbility?.name else { return }
        if abilityVideo == nil {
            ability = await getVideoURL(abilityName, type: .non)
        }
        if scepterVideo == nil {
            scepter = await getVideoURL(abilityName, type: .scepter)
        }
        if shardVideo == nil {
            shard = await getVideoURL(abilityName, type: .shard)
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
    
    private func getVideoURL(_ ability: String, type: ScepterType) async -> AVAsset? {
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
        let isPlayable = await video.isPlayable()
        
        return isPlayable ? video : nil
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
