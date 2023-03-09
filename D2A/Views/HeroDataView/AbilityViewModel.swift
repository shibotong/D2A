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
    
    @Published var scepterVideo: AVAsset?
    @Published var shardVideo: AVAsset?
    @Published var abilityVideo: AVAsset?
    
    private var database = HeroDatabase.shared
    private var abilityName: String
        
    init(heroID: Int, abilityName: String) {
        print("build \(abilityName)")
        stratzAbility = database.fetchStratzAbility(name: abilityName)
        opentDotaAbility = database.fetchOpenDotaAbility(name: abilityName)
        self.heroID = heroID
        self.abilityName = abilityName
    }
    
    func buildDetailView() async {
        let abilityVideo = getVideoURL(abilityName, type: .non)
        let scepterVideo = getVideoURL(abilityName, type: .scepter)
        let shardVideo = getVideoURL(abilityName, type: .shard)
        await setVideoURL(ability: abilityVideo, scepter: scepterVideo, shard: shardVideo)
    }
    
    @MainActor
    private func setVideoURL(ability: AVAsset?, scepter: AVAsset?, shard: AVAsset?) {
        abilityVideo = ability
        scepterVideo = scepter
        shardVideo = shard
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
    
    func getPlayer(asset: AVAsset) -> AVPlayer {
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        player.isMuted = true
        return player
    }
    
    private func addObserver(player: AVPlayer) {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: nil) { _ in
                player.seek(to: .zero)
                player.play()
            }
    }
    
    func removeObserver(player: AVPlayer) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func playVideo(item: AVPlayerItem, player: AVPlayer) async {
        if item.status == .readyToPlay {
            await player.play()
            addObserver(player: player)
        } else {
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                await playVideo(item: item, player: player)
            } catch {
                print(error)
            }
        }
    }
    
    func removeVideos() {
        abilityVideo = nil
        shardVideo = nil
        scepterVideo = nil
    }
}
