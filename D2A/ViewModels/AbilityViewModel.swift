//
//  AbilityViewModel.swift
//  App
//
//  Created by Shibo Tong on 11/6/2022.
//

import Foundation
import AVFoundation

class AbilityViewModel: ObservableObject {
    var ability: Ability
    var heroID: Int
    var abilityName: String
    
    @Published var scepterVideo: URL? = nil
    @Published var shardVideo: URL? = nil
    @Published var abilityVideo: URL? = nil
    
    private var database = HeroDatabase.shared
    
    init(ability: Ability, heroID: Int, abilityName: String) {
        self.ability = ability
        self.heroID = heroID
        self.abilityName = abilityName
        Task {
            await buildDetailView()
        }
    }
    
    private func buildDetailView() async {
        let abilityVideo = self.getVideoURL(abilityName, type: .non)
        let scepterVideo = self.getVideoURL(abilityName, type: .Scepter)
        let shardVideo = self.getVideoURL(abilityName, type: .Shard)
        await self.setVideoURL(ability: abilityVideo, scepter: scepterVideo, shard: shardVideo)
    }
    
    @MainActor
    private func setVideoURL(ability: URL?, scepter: URL?, shard: URL?) {
        self.abilityVideo = ability
        self.scepterVideo = scepter
        self.shardVideo = shard
    }
    
    private func getVideoURL(_ ability: String, type: ScepterType) -> URL? {
        guard let heroName = database.heroes["\(heroID)"]?.name.replacingOccurrences(of: "npc_dota_hero_", with: "") else {
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
            guard let url = URL(string: "\(baseURL)/\(abilityName).mp4") else {
                return nil
            }
            if AVAsset(url: url).isPlayable {
                return url
            } else {
                return nil
            }
        }
    }
    
    func getPlayer(url: URL) -> AVPlayer {
        let player = AVPlayer(url: url)
        player.isMuted = true
        return player
    }
    
    func addObserver(player: AVPlayer) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: nil) { notif in
            player.seek(to: .zero)
            player.play()
        }
    }
    
    func removeObserver(player: AVPlayer) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}
