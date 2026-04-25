//
//  AbilityView.swift
//  App
//
//  Created by Shibo Tong on 26/8/2022.
//

import SwiftUI
import AVKit
import StratzAPI

enum ScepterType: String {
    case scepter
    case shard
    case non
    
    var upgradeString: LocalizedStringKey {
        switch self {
        case .scepter:
            return LocalizedStringKey("SCEPTER UPGRADE")
        case .shard:
            return LocalizedStringKey("SHARD UPGRADE")
        case .non:
            return LocalizedStringKey("")
        }
    }
}

struct AbilityView: View {
    
    let heroName: String
    
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

    let description: String?
    let scepter: String?
    let shard: String?
    
    let lore: String?
    let attributes: [AbilityTranslation.Attribute]?
    
    // AbilityDescriptionView
    @State var scepterVideo: AVPlayer?
    @State var shardVideo: AVPlayer?
    @State var abilityVideo: AVPlayer?
    
    init(heroName: String, ability: Ability) {
        self.init(heroName: heroName, displayName: ability.displayName, cd: ability.coolDown,
                  mc: ability.manaCost, name: ability.name, behavior: ability.behavior,
                  targetTeam: ability.targetTeam, bkbPierce: ability.bkbPierce, dispellable: ability.dispellable,
                  damageType: ability.damageType, description: ability.desc, scepter: ability.scepter, shard: ability.shard,
                  lore: ability.lore, attributes: ability.localizedAttributes)
    }
    
    init(heroName: String, displayName: String, cd: String?,
         mc: String?, name: String?, behavior: String?,
         targetTeam: String?, bkbPierce: String?, dispellable: String?,
         damageType: String?, scepterVideo: AVPlayer? = nil,
         shardVideo: AVPlayer? = nil, abilityVideo: AVPlayer? = nil,
         description: String?, scepter: String?, shard: String?,
         lore: String?, attributes: [AbilityTranslation.Attribute]?) {
        self.heroName = heroName
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
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    AbilityTitleView(displayName: displayName,
                                     cd: cd,
                                     mc: mc,
                                     name: name ?? "")
                    AbilityStatsView(behavior: behavior,
                                     targetTeam: targetTeam,
                                     bkbPierce: bkbPierce,
                                     dispellable: dispellable,
                                     damageType: damageType)
                    buildDescription(proxy: proxy)
                    Spacer().frame(height: 10)
                    if let attributes {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                ForEach(attributes, id: \.self) { item in
                                    AbilityStatsTextView(title: item.name, message: item.description)
                                }
                            }
                            Spacer()
                        }
                    }
                    Spacer().frame(height: 10)
                    if let lore {
                        Text(lore)
                            .font(.system(size: 10))
                            .padding(8)
                            .foregroundColor(Color(UIColor.tertiaryLabel))
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(Color(UIColor.tertiarySystemBackground))
                            )
                    }
                }
                .padding(.vertical)
            }
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            buildDetailView()
        }
    }
    
    @ViewBuilder
    private func buildDescription(proxy: GeometryProxy) -> some View {
        VStack {
            if let description {
                AbilityDescriptionView(width: proxy.size.width, type: .non, description: description, player: abilityVideo)
            }
            if let scepter {
                AbilityDescriptionView(width: proxy.size.width, type: .scepter, description: scepter, player: scepterVideo)
            }
            if let shard {
                AbilityDescriptionView(width: proxy.size.width, type: .shard, description: shard, player: shardVideo)
            }
        }
    }
    
    func buildDetailView() {
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
        setVideoURL(ability: ability, scepter: scepter, shard: shard)
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
        let trimmedHeroName = heroName.replacingOccurrences(of: "npc_dota_hero_", with: "")
        let baseURL = "\(IMAGE_PREFIX)/apps/dota2/videos/dota_react/abilities/\(trimmedHeroName)"
        var path = ""
        switch type {
        case .scepter:
            path = "\(baseURL)/\(trimmedHeroName)_aghanims_scepter.mp4"
        case .shard:
            path = "\(baseURL)/\(trimmedHeroName)_aghanims_shard.mp4"
        case .non:
            path = "\(baseURL)/\(ability).mp4"
        }

        guard let video = CacheVideo.shared.getVideo(key: path, name: heroName) else {
            return nil
        }
        return video.isPlayable ? video: nil
    }
}

#Preview("Blink") {
    AbilityView(heroName: "npc_dota_hero_antimage", ability: PreviewData.PreviewAbility.blink)
        .environmentObject(PreviewData.environment)
}
    
#Preview("Counterspell") {
    AbilityView(heroName: "npc_dota_hero_antimage", ability: PreviewData.PreviewAbility.counterspell)
        .environmentObject(PreviewData.environment)
}

#Preview("Mana Break") {
    AbilityView(heroName: "npc_dota_hero_antimage", ability: PreviewData.PreviewAbility.manaBreak)
        .environmentObject(PreviewData.environment)
}

#Preview("Mana Void") {
    AbilityView(heroName: "npc_dota_hero_antimage", ability: PreviewData.PreviewAbility.manaVoid)
        .environmentObject(PreviewData.environment)
}

