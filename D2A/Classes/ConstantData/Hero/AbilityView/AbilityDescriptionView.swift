//
//  AbilityDescriptionView.swift
//  D2A
//
//  Created by Shibo Tong on 21/1/2024.
//

import SwiftUI
import AVKit

struct AbilityDescriptionView: View {
    
    var width: CGFloat
    
    var type: ScepterType
    var description: String
    var player: AVPlayer?
    
    var body: some View {
        VStack(alignment: .leading) {
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
                HStack {
                    Spacer()
                    VideoPlayer(player: player)
                        .frame(width: width - 40,
                               height: (width - 40.0) / 16.0 * 9.0)
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
                    Spacer()
                }
            }
            
        }
        .padding(10)
        .background(calculateDescBackground(type: type))
    }
    
    @ViewBuilder private func calculateDescBackground(type: ScepterType) -> some View {
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

struct AbilityDescriptionView_Previews: PreviewProvider {
    static let player: AVPlayer = {
        let urlString = "https://cdn.cloudflare.steamstatic.com/apps/dota2/videos/dota_react/abilities/alchemist/alchemist_unstable_concoction.mp4"
        let asset = AVAsset(url: URL(string: urlString)!)
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        return player
    }()
    static var previews: some View {
        Group {
            AbilityDescriptionView(width: 300, type: .non, description: "this is description", player: player)
            AbilityDescriptionView(width: 300, type: .scepter, description: "this is description", player: player)
            AbilityDescriptionView(width: 300, type: .shard, description: "this is description", player: player)
        }
        .previewLayout(.fixed(width: 300, height: 500))
    }
}
