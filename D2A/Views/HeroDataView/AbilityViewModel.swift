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
    
    @Published var scepterVideo: URL?
    @Published var shardVideo: URL?
    @Published var abilityVideo: URL?
    
    private var database = HeroDatabase.shared
    
    init(heroID: Int, abilityName: String) {
        stratzAbility = database.fetchStratzAbility(name: abilityName)
        opentDotaAbility = database.fetchOpenDotaAbility(name: abilityName)
        self.heroID = heroID
        Task {
            await buildDetailView(name: abilityName)
        }
    }
    
    private func buildDetailView(name: String) async {
        let abilityVideo = getVideoURL(name, type: .non)
        let scepterVideo = getVideoURL(name, type: .scepter)
        let shardVideo = getVideoURL(name, type: .shard)
        await setVideoURL(ability: abilityVideo, scepter: scepterVideo, shard: shardVideo)
    }
    
    @MainActor
    private func setVideoURL(ability: URL?, scepter: URL?, shard: URL?) {
        abilityVideo = ability
        scepterVideo = scepter
        shardVideo = shard
    }
    
    private func getVideoURL(_ ability: String, type: ScepterType) -> URL? {
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
        return AVAsset(url: url).isPlayable ? url : nil
    }
    
    func getPlayer(url: URL) -> AVPlayer {
        let player = AVPlayer(url: url)
        player.isMuted = true
        return player
    }
    
    func addObserver(player: AVPlayer) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: nil) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
    
    func removeObserver(player: AVPlayer) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}
