//
//  AbilityDescriptionViewV2.swift
//  D2A
//
//  Created by Shibo Tong on 22/9/2024.
//

import SwiftUI

import AVKit

struct AbilityDescriptionViewV2: View {
    
    private let type: ScepterType
    private let description: String
    private let videoURL: String?
    
    @State private var player: AVPlayer?
    
    init(type: ScepterType, description: String, name: String? = nil, heroName: String? = nil) {
        var videoURL: String? = nil
        if let heroName, let name {
            let baseURL = "\(IMAGE_PREFIX)/apps/dota2/videos/dota_react/abilities/\(heroName)"
            switch type {
            case .scepter:
                videoURL = "\(baseURL)/\(heroName)_aghanims_scepter.mp4"
            case .shard:
                videoURL = "\(baseURL)/\(heroName)_aghanims_shard.mp4"
            case .non:
                videoURL = "\(baseURL)/\(name).mp4"
            }
        }
        
        self.init(type: type, description: description, videoURL: videoURL)
    }
    
    init(type: ScepterType, description: String, videoURL: String? = nil) {
        self.type = type
        self.description = description
        self.videoURL = videoURL
    }
    
    var body: some View {
        VStack {
            if type != .non {
                HStack {
                    Image("\(type.rawValue.lowercased())_1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                    Text(type.upgradeString)
                        .font(.system(size: 15))
                        .bold()
                    Spacer()
                }
            }
            Text(description)
                .font(.system(size: 13))
            if let player {
                VideoPlayer(player: player)
                    .frame(width: 320, height: 180)
                    .disabled(true)
                    .onAppear {
                        player.seek(to: .zero)
                        player.play()
                        NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: player.currentItem,
                            queue: nil) { _ in
                                player.seek(to: .zero)
                                player.play()
                            }
                    }
                    .onDisappear {
                        player.pause()
                        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                    }
            }
        }
        .padding(10)
        .background(background.padding(2))
        .task {
            await loadVideo()
        }
    }
    
    private var background: some View {
        Group {
            switch type {
            case .scepter:
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
            case .shard:
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
            case .non:
                EmptyView()
            }
        }
    }
    
    private func loadVideo() async {
        guard let videoURL,
              let url = URL(string: videoURL) else {
            print("url error")
            return
        }
        let asset = AVAsset(url: url)
        do {
            let playable = try await asset.load(.isPlayable)
            player = playable ? AVPlayer(playerItem: AVPlayerItem(asset: asset)) : nil
            Logger.shared.log(level: .verbose, message: "loading video \(videoURL)")
        } catch {
            Logger.shared.log(level: .warning, message: "No video url \(videoURL)")
            return
        }
    }
}

struct AbilityDescriptionViewV2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AbilityDescriptionViewV2(type: .non, 
                                     description: "this is description",
                                     videoURL: "https://cdn.cloudflare.steamstatic.com/apps/dota2/videos/dota_react/abilities/alchemist/alchemist_unstable_concoction.mp4")
            AbilityDescriptionViewV2(type: .scepter, 
                                     description: "this is description",
                                     videoURL: "https://cdn.cloudflare.steamstatic.com/apps/dota2/videos/dota_react/abilities/alchemist/alchemist_unstable_concoction.mp4")
            AbilityDescriptionViewV2(type: .shard, 
                                     description: "this is description",
                                     videoURL: "https://cdn.cloudflare.steamstatic.com/apps/dota2/videos/dota_react/abilities/alchemist/alchemist_unstable_concoction.mp4")
        }
        .previewLayout(.fixed(width: 300, height: 500))
    }
}
