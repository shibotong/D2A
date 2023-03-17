//
//  AbilityViewModel.swift
//  App
//
//  Created by Shibo Tong on 11/6/2022.
//

import Foundation
import AVFoundation
import StratzAPI

class AbilityViewModel: ObservableObject {
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
        var url: URL?
        switch type {
        case .scepter:
            url = URL(string: "\(baseURL)/\(heroName)_aghanims_scepter.mp4")
        case .shard:
            url = URL(string: "\(baseURL)/\(heroName)_aghanims_shard.mp4")
        case .non:
            url = URL(string: "\(baseURL)/\(ability).mp4")
        }
        guard let url = url else { return nil }
        let asset = AVAsset(url: url)
        return asset.isPlayable ? asset : nil
    }
}
