//
//  MiniMapView.swift
//  D2A
//
//  Created by Shibo Tong on 22/10/2022.
//

import SwiftUI

enum BuildingType {
    case tower
    case barrack
    case base
}

struct MiniMapView: View {
    
    var players: [MatchLiveSubscription.Data.MatchLive.Player?]?
    // 10010 01000 00001 11001 00100
    var buildingState: Long?
    
    var body: some View {
//        GeometryReader { proxy in
            ZStack {
                Image("minimap")
                    .resizable()
                    .scaledToFit()
                    .overlay(Color.black.opacity(0.1))
                buildings()
                if let players = players {
                    ForEach(players.compactMap{ $0 }, id: \.heroId) { player in
                        if let heroIdDouble = player.heroId,
                           let heroId = Int(heroIdDouble),
                           let xPos = player.playbackData?.positionEvents?.first??.x,
                           let yPos = player.playbackData?.positionEvents?.first??.y {
                            buildHeroIconPosition(heroId: heroId, x: xPos, y: yPos)
                        }
                    }
                }
            }
//            .frame(width: proxy.size.width, height: proxy.size.width)
//        }
            
    }
    
    @ViewBuilder private func buildHeroIconPosition(heroId: Int,
                                                    x: Int,
                                                    y: Int) -> some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let offSet: CGFloat = 65
            let fullSide: CGFloat = 255.0 - offSet * 2
            let trueY = 255.0 - CGFloat(y) - offSet
            let trueX = CGFloat(x) - offSet
            HeroImageView(heroID: heroId, type: .icon)
                .frame(width: width / 12, height: width / 12)
                .position(x: width * trueX / fullSide, y: width * trueY / fullSide)
        }
    }
    
    @ViewBuilder private func buildings() -> some View {
        Group {
            Group {
                // Radiant Top Lane
                buildTower(isRadiant: true, x: 18, y: 91)
                buildTower(isRadiant: true, x: 18, y: 136)
                buildTower(isRadiant: true, x: 13, y: 177)
                buildTower(isRadiant: true, x: 10, y: 184, type: .barrack)
                buildTower(isRadiant: true, x: 19, y: 184, type: .barrack)
            }
            Group {
                // Radiant Mid Lane
                buildTower(isRadiant: true, x: 67, y: 166)
                buildTower(isRadiant: true, x: 96, y: 144)
                buildTower(isRadiant: true, x: 45, y: 188)
                buildTower(isRadiant: true, x: 46, y: 197, type: .barrack)
                buildTower(isRadiant: true, x: 39, y: 191, type: .barrack)
            }
            Group {
                // Radiant Btm Lane
                buildTower(isRadiant: true, x: 204, y: 222)
                buildTower(isRadiant: true, x: 117, y: 224)
                buildTower(isRadiant: true, x: 57, y: 221)
                buildTower(isRadiant: true, x: 52, y: 217, type: .barrack)
                buildTower(isRadiant: true, x: 52, y: 227, type: .barrack)
            }
            Group {
                // Radiant Base
                buildTower(isRadiant: true, x: 33, y: 207) // right tower
                buildTower(isRadiant: true, x: 27, y: 201) // left tower
                buildTower(isRadiant: true, x: 23, y: 207, type: .base) // base
            }
            Group {
                // Dire Top Lane
                buildTower(isRadiant: false, x: 45, y: 23)
                buildTower(isRadiant: false, x: 119, y: 21)
                buildTower(isRadiant: false, x: 180, y: 25)
                buildTower(isRadiant: false, x: 187, y: 23, type: .barrack)
                buildTower(isRadiant: false, x: 187, y: 31, type: .barrack)
            }
            Group {
                // Dire Mid Lane
                buildTower(isRadiant: false, x: 132, y: 110)
                buildTower(isRadiant: false, x: 162, y: 86)
                buildTower(isRadiant: false, x: 191, y: 59)
                buildTower(isRadiant: false, x: 193, y: 53, type: .barrack)
                buildTower(isRadiant: false, x: 200, y: 59, type: .barrack)
            }
            Group {
                // Dire Btm Lane
                buildTower(isRadiant: false, x: 225, y: 149)
                buildTower(isRadiant: false, x: 225, y: 115)
                buildTower(isRadiant: false, x: 225, y: 72)
                buildTower(isRadiant: false, x: 222, y: 67, type: .barrack)
                buildTower(isRadiant: false, x: 232, y: 67, type: .barrack)
            }
            Group {
                // Dire Base
                buildTower(isRadiant: false, x: 209, y: 48) // right tower
                buildTower(isRadiant: false, x: 203, y: 42) // left tower
                buildTower(isRadiant: false, x: 211, y: 36, type: .base) // base
            }
        }
    }
    
    @ViewBuilder private func buildTower(isRadiant: Bool, x: Int, y: Int, type: BuildingType = .tower) -> some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let scale = fetchScale(type: type)
            let towerWidth: CGFloat = width / scale
            let offSet: CGFloat = towerWidth / 3
            let fullSide: CGFloat = 255.0
            let trueY = CGFloat(y) + offSet
            let trueX = CGFloat(x) + offSet
            if type == .tower {
                Circle()
                    .foregroundColor(isRadiant ? .green : .red)
                    .frame(width: towerWidth, height: towerWidth)
                    .position(x: width * trueX / fullSide, y: width * trueY / fullSide)
            } else {
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(isRadiant ? .green : .red)
                    .frame(width: towerWidth, height: towerWidth)
                    .position(x: width * trueX / fullSide, y: width * trueY / fullSide)
            }
        }
    }
    
    private func fetchScale(type: BuildingType) -> CGFloat {
        switch type {
        case .tower:
            return 30
        case .barrack:
            return 40
        case .base:
            return 25
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MiniMapView()
                .previewLayout(.fixed(width: 200, height: 200))
        }
    }
}
