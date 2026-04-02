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
    
    @Published var description: String?
    @Published var scepter: String?
    @Published var shard: String?
    
    @Published var lore: String?
    @Published var attributes: [StratzAttribute]?
    
    // Ability Data
    @Published var opentDotaAbility: ODAbility?
    
    private var database = HeroDatabase.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    private let persistenceProvider: PersistenceProviding
        
    init(heroID: Int, ability: ODAbility?,
         persistenceProvider: PersistenceProviding = PersistenceProvider.shared) {
        self.heroID = heroID
        self.opentDotaAbility = ability
        self.persistenceProvider = persistenceProvider
        let context = persistenceProvider.mainContext
        if let localisation = try? AbilityTranslation.fetch(name: ability?.name ?? "", language: AppConfig.languageCode, context: context) {
            setLocalisation(localisation: localisation)
        }
        
        if let name = ability?.name, let savedAbility = try? persistenceProvider.fetch(ability: name, context: context) {
            setAbiilty(savedAbility)
        } else {
            setupBinding()
        }
        Task {
            await buildDetailView()
        }
    }
    
    private func setLocalisation(localisation: AbilityTranslation) {
        displayName = localisation.displayName ?? ""
        lore = localisation.lore
        description = localisation.desc
        scepter = localisation.aghanimDescription
        shard = localisation.shardDescription
        attributes = localisation.localizedAttributes
    }
    
    private func setAbiilty(_ ability: Ability) {
        cd = ability.coolDown
        mc = ability.manaCost
        behavior = ability.behavior
        targetTeam = ability.targetTeam
        bkbPierce = ability.bkbPierce
        dispellable = ability.dispellable
        damageType = ability.damageType

        guard let name = ability.name else {
            return
        }
        let urlString = "\(IMAGE_PREFIX)/apps/dota2/images/dota_react/abilities/\(name).png"
        abilityImageURL = urlString
    }
    
    private func setupBinding() {
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
