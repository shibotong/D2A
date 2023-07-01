//
//  LiveMatchMapView.swift
//  D2A
//
//  Created by Shibo Tong on 9/6/2023.
//

import SwiftUI
import StratzAPI

struct LiveMatchMapView: View {
    
    var heroes: [LiveMatchHeroPosition]
    
    var buildings: [LiveMatchBuildingEvent]
    
    var body: some View {
        Image("live_map")
            .resizable()
            .scaledToFit()
            .background(Color.label.opacity(0.3))
            .overlay {
                ZStack {
                    GeometryReader { proxy in
                        let sideLength = proxy.size.width
                        
                        ForEach(buildings) { building in
                            let xPos = calculatePosition(totalLength: sideLength, position: building.position.x, isX: true)
                            let yPos = calculatePosition(totalLength: sideLength, position: building.position.y, isX: false)
                            let forgroundColor: Color = building.isAlive ? building.isRadiant ? .green : .red : .black
                            ZStack {
                                if building.type == .case(.tower) {
                                    let frame = sideLength / 27
                                    Circle()
                                        .frame(width: frame, height: frame)
                                } else if building.type == .case(.barracks) {
                                    let frame = sideLength / 40
                                    Rectangle()
                                        .frame(width: frame, height: frame)
                                } else {
                                    let frame = sideLength / 27
                                    Rectangle()
                                        .frame(width: frame, height: frame)
                                }
                            }
                            .position(x: xPos, y: yPos)
                            .foregroundColor(forgroundColor)
                        }
                        
                        ForEach(heroes) { hero in
                            let xPos = calculatePosition(totalLength: sideLength, position: hero.xPos, isX: true)
                            let yPos = calculatePosition(totalLength: sideLength, position: hero.yPos, isX: false)
                            HeroImageView(heroID: hero.heroID, type: .icon)
                                .frame(width: sideLength / 15)
                                .position(x: xPos, y: yPos)
                                .animation(.linear, value: hero)
                        }
                    }
                }
            }
    }
    
    private func calculatePosition(totalLength: CGFloat, position: CGFloat, isX: Bool) -> CGFloat {
        let midPoint: CGFloat = 127
        
        let xStartPoint: CGFloat = 76
        let xEndPoint = midPoint - xStartPoint + midPoint
        let xLength = xEndPoint - xStartPoint
        
        let yStartPoint: CGFloat = 76
        let yEndPoint = midPoint - yStartPoint + midPoint
        let yLength = yEndPoint - yStartPoint
        
        if isX {
            return (totalLength * (position - xStartPoint) / xLength)
        } else {
            return (totalLength - (totalLength * (position - yStartPoint) / yLength))
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

struct LiveMatchMapView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchMapView(heroes: [.init(heroID: 1, xPos: 127, yPos: 127)], buildings: [])
    }
}
