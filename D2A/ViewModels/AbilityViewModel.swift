//
//  AbilityViewModel.swift
//  App
//
//  Created by Shibo Tong on 11/6/2022.
//

import Foundation
import AVFoundation

class AbilityViewModel: ObservableObject {
    let heroID: Int
    
    @Published var stratzAbility: AbilityQuery.Data.Constant.Ability?
    @Published var opentDotaAbility: Ability?
    
    @Published var scepterVideo: URL? = nil
    @Published var shardVideo: URL? = nil
    @Published var abilityVideo: URL? = nil
    
    private var database = HeroDatabase.shared
    
    init(heroID: Int, abilityName: String) {
        self.stratzAbility = database.fetchStratzAbility(name: abilityName)
        self.opentDotaAbility = database.fetchOpenDotaAbility(name: abilityName)
        
        self.heroID = heroID
        Task {
            await buildDetailView(name: abilityName)
        }
    }
    
    private func buildDetailView(name: String) async {
        let abilityVideo = self.getVideoURL(name, type: .non)
        let scepterVideo = self.getVideoURL(name, type: .Scepter)
        let shardVideo = self.getVideoURL(name, type: .Shard)
        await self.setVideoURL(ability: abilityVideo, scepter: scepterVideo, shard: shardVideo)
    }
    
    @MainActor
    private func setVideoURL(ability: URL?, scepter: URL?, shard: URL?) {
        self.abilityVideo = ability
        self.scepterVideo = scepter
        self.shardVideo = shard
    }
    
    private func getVideoURL(_ ability: String, type: ScepterType) -> URL? {
        guard let heroName = try? database.fetchHeroWithID(id: heroID).name.replacingOccurrences(of: "npc_dota_hero_", with: "") else {
            return nil
        }
        let baseURL = "https://cdn.cloudflare.steamstatic.com/apps/dota2/videos/dota_react/abilities/\(heroName)"
        switch type {
        case .Scepter:
            guard let url = URL(string: "\(baseURL)/\(heroName)_aghanims_scepter.mp4") else {
                return nil
            }
            if AVAsset(url: url).isPlayable {
                return url
            } else {
                return nil
            }
        case .Shard:
            guard let url = URL(string: "\(baseURL)/\(heroName)_aghanims_shard.mp4") else {
                return nil
            }
            if AVAsset(url: url).isPlayable {
                return url
            } else {
                return nil
            }
        case .non:
            guard let url = URL(string: "\(baseURL)/\(ability).mp4") else {
                return nil
            }
            if AVAsset(url: url).isPlayable {
                return url
            } else {
                return nil
            }
        }
    }
}
