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
    
    var buildings: [LiveMatchBuildingEvents]
    
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
                            let xPos = calculatePosition(totalLength: sideLength, position: building.xPos, isX: true)
                            let yPos = calculatePosition(totalLength: sideLength, position: building.yPos, isX: false)
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
                                .frame(width: sideLength / 11)
                                .position(x: xPos, y: yPos)
                                .animation(.linear, value: hero)
                        }
                    }
                }
            }
    }
    
    private func calculatePosition(totalLength: CGFloat, position: CGFloat, isX: Bool) -> CGFloat {
        let midPoint: CGFloat = 127
        
        let xStartPoint: CGFloat = 75
        let xEndPoint = midPoint - xStartPoint + midPoint
        let xLength = xEndPoint - xStartPoint
        
        let yStartPoint: CGFloat = 77
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
        LiveMatchMapView(heroes: [.init(heroID: 1, xPos: 127, yPos: 127)], buildings: [
            .init(indexId: 0, time: 60, type: .case(.tower), isAlive: true, xPos: 87, yPos: 140, isRadiant: true),
            .init(indexId: 1, time: 60, type: .case(.tower), isAlive: true, xPos: 88, yPos: 123, isRadiant: true),
            .init(indexId: 2, time: 60, type: .case(.tower), isAlive: true, xPos: 86, yPos: 108, isRadiant: true),
            .init(indexId: 3, time: 60, type: .case(.tower), isAlive: true, xPos: 117, yPos: 120, isRadiant: true),
            .init(indexId: 4, time: 60, type: .case(.tower), isAlive: true, xPos: 106, yPos: 112, isRadiant: true),
            .init(indexId: 5, time: 60, type: .case(.tower), isAlive: true, xPos: 98, yPos: 103, isRadiant: true),
            .init(indexId: 6, time: 60, type: .case(.tower), isAlive: true, xPos: 158, yPos: 92, isRadiant: true),
            .init(indexId: 7, time: 60, type: .case(.tower), isAlive: true, xPos: 125, yPos: 90, isRadiant: true),
            .init(indexId: 8, time: 60, type: .case(.tower), isAlive: true, xPos: 102, yPos: 91, isRadiant: true),
            .init(indexId: 9, time: 60, type: .case(.tower), isAlive: true, xPos: 91, yPos: 99, isRadiant: true),
            .init(indexId: 10, time: 60, type: .case(.tower), isAlive: true, xPos: 93, yPos: 97, isRadiant: true),
            .init(indexId: 11, time: 60, type: .case(.barracks), isAlive: true, xPos: 87, yPos: 106, isRadiant: true),
            .init(indexId: 12, time: 60, type: .case(.barracks), isAlive: true, xPos: 84, yPos: 106, isRadiant: true),
            .init(indexId: 13, time: 60, type: .case(.barracks), isAlive: true, xPos: 98, yPos: 101, isRadiant: true),
            .init(indexId: 14, time: 60, type: .case(.barracks), isAlive: true, xPos: 95, yPos: 103, isRadiant: true),
            .init(indexId: 15, time: 60, type: .case(.barracks), isAlive: true, xPos: 100, yPos: 90, isRadiant: true),
            .init(indexId: 16, time: 60, type: .case(.barracks), isAlive: true, xPos: 100, yPos: 93, isRadiant: true),
            .init(indexId: 17, time: 60, type: .case(.fort), isAlive: true, xPos: 90, yPos: 96, isRadiant: true),
            .init(indexId: 18, time: 60, type: .case(.tower), isAlive: true, xPos: 98, yPos: 165, isRadiant: false),
            .init(indexId: 19, time: 60, type: .case(.tower), isAlive: true, xPos: 126, yPos: 165, isRadiant: false),
            .init(indexId: 20, time: 60, type: .case(.tower), isAlive: true, xPos: 149, yPos: 164, isRadiant: false),
            .init(indexId: 21, time: 60, type: .case(.tower), isAlive: true, xPos: 130, yPos: 133, isRadiant: false),
            .init(indexId: 22, time: 60, type: .case(.tower), isAlive: true, xPos: 143, yPos: 141, isRadiant: false),
            .init(indexId: 23, time: 60, type: .case(.tower), isAlive: true, xPos: 154, yPos: 151, isRadiant: false),
            .init(indexId: 24, time: 60, type: .case(.tower), isAlive: true, xPos: 166, yPos: 115, isRadiant: false),
            .init(indexId: 25, time: 60, type: .case(.tower), isAlive: true, xPos: 167, yPos: 131, isRadiant: false),
            .init(indexId: 26, time: 60, type: .case(.tower), isAlive: true, xPos: 167, yPos: 147, isRadiant: false),
            .init(indexId: 27, time: 60, type: .case(.tower), isAlive: true, xPos: 158, yPos: 158, isRadiant: false),
            .init(indexId: 28, time: 60, type: .case(.tower), isAlive: true, xPos: 160, yPos: 156, isRadiant: false),
            .init(indexId: 29, time: 60, type: .case(.barracks), isAlive: true, xPos: 151, yPos: 162, isRadiant: false),
            .init(indexId: 30, time: 60, type: .case(.barracks), isAlive: true, xPos: 151, yPos: 165, isRadiant: false),
            .init(indexId: 31, time: 60, type: .case(.barracks), isAlive: true, xPos: 156, yPos: 152, isRadiant: false),
            .init(indexId: 32, time: 60, type: .case(.barracks), isAlive: true, xPos: 154, yPos: 154, isRadiant: false),
            .init(indexId: 33, time: 60, type: .case(.barracks), isAlive: true, xPos: 168, yPos: 149, isRadiant: false),
            .init(indexId: 34, time: 60, type: .case(.barracks), isAlive: true, xPos: 165, yPos: 149, isRadiant: false),
            .init(indexId: 35, time: 60, type: .case(.fort), isAlive: false, xPos: 162, yPos: 159, isRadiant: false)
        ])
    }
}
