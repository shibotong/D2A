//
//  MiniMapView.swift
//  D2A
//
//  Created by Shibo Tong on 22/10/2022.
//

import SwiftUI

struct MiniMapView: View {
    
    var players: [Player]
    var buildingEvents: [BuildingEvent]
    
    var body: some View {
        ZStack {
            Image("minimap")
                .resizable()
                .scaledToFit()
                .overlay(Color.black.opacity(0.2))
            GeometryReader { proxy in
                ForEach(buildingEvents, id:\.indexId) { event in
                    buildIconOnMap(proxy: proxy, tower: event)
                }
                if let players = players {
                    ForEach(players, id: \.accountId) { player in
                        buildIconOnMap(proxy: proxy, player: player)
                            .animation(.linear)
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func buildIconOnMap(proxy: GeometryProxy, player: Player? = nil, tower: BuildingEvent? = nil) -> some View {
        let width = proxy.size.width
        let offSet: CGFloat = 68
        let fullSide: CGFloat = 255.0 - offSet * 2
        if let player = player, let x = player.positionX, let y = player.positionY {
            let trueY = 255.0 - CGFloat(y) - offSet
            let trueX = CGFloat(x) - offSet
            HeroImageView(heroID: player.heroID, type: .icon)
                .frame(width: width / 12, height: width / 12)
                .position(x: width * trueX / fullSide, y: width * trueY / fullSide)
        }
        if let tower = tower, let x = tower.positionX, let y = tower.positionY {
            let scale = tower.type.scale
            let towerWidth: CGFloat = width / scale
            let trueY = 255.0 - CGFloat(y) - offSet
            let trueX = CGFloat(x) - offSet
            let color: Color = tower.isAlive ? tower.isRadiant ? .green : .red : .gray
            if tower.type == .tower {
                Circle()
                    .foregroundColor(color)
                    .frame(width: towerWidth, height: towerWidth)
                    .position(x: width * trueX / fullSide, y: width * trueY / fullSide)
            } else {
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(color)
                    .frame(width: towerWidth, height: towerWidth)
                    .position(x: width * trueX / fullSide, y: width * trueY / fullSide)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MiniMapView(players: [], buildingEvents: [])
                .previewLayout(.fixed(width: 200, height: 200))
        }
    }
}
