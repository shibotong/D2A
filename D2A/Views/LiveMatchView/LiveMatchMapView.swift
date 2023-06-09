//
//  LiveMatchMapView.swift
//  D2A
//
//  Created by Shibo Tong on 9/6/2023.
//

import SwiftUI

struct LiveMatchMapView: View {
    
    var heroes: [LiveMatchHeroPosition]
    
    var body: some View {
        Image("live_map")
            .resizable()
            .scaledToFit()
            .background(Color.label.opacity(0.3))
            .overlay {
                ZStack {
                    GeometryReader { proxy in
                        let sideLength = proxy.size.width
                        let totalLength: CGFloat = 127.0
                        let startPoint = totalLength / 2
                        ForEach(heroes) { hero in
                            let xPos = (sideLength * (hero.xPos - startPoint) / totalLength)
                            let yPos = (sideLength - (sideLength * (hero.yPos - startPoint) / totalLength))
                            HeroImageView(heroID: hero.heroID, type: .icon)
                                .frame(width: sideLength / 11)
                                .position(x: xPos, y: yPos)
                                .animation(.linear, value: hero)
                        }
                    }
                    
                }
            }
    }
}

struct LiveMatchHeroPosition: Identifiable, Equatable {
    var id: Int {
        return heroID
    }
    
    let heroID: Int
    let xPos: CGFloat
    let yPos: CGFloat
    
}

struct LiveMatchBuildingEvents: Identifiable {
    
    var id: Int {
        return indexId
    }
    
    let indexId: Int
    let time: Int
    let type: String
    let isAlive: Bool
    let xPos: CGFloat
    let yPos: CGFloat
    let isRadiant: Bool
    let npcId: Int
}

struct LiveMatchMapView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchMapView(heroes: [
            .init(heroID: 1, xPos: 127, yPos: 127)
        ])
    }
}
