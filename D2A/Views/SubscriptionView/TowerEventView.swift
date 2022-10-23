//
//  TowerEventView.swift
//  D2A
//
//  Created by Shibo Tong on 23/10/2022.
//

import SwiftUI

struct TowerEventView: View {
    
    var event: TowerEvent
    
    var body: some View {
        HStack {
            if event.isRadiant {
                MatchLiveTimeLabel(time: event.time)
                Spacer()
            } else {
                Image("radiant_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            Text("Destroyed")
                .font(.custom(fontString, size: 12))
                .foregroundColor(.secondaryLabel)
            Rectangle()
                .foregroundColor(event.isRadiant ? .green : .red)
                .frame(width: 10, height: 10)
            Text(event.towerString)
                .font(.custom(fontString, size: 12)).bold()
            if !event.isRadiant {
                Spacer()
                MatchLiveTimeLabel(time: event.time)
            } else {
                Image("dire_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
}

struct MatchLiveTimeLabel: View {
    
    var time: Int
    
    var body: some View {
        Text(time.convertToDuration())
            .font(.custom(fontString, size: 10))
            .foregroundColor(.tertiaryLabel)
    }
}

struct TowerEventView_Previews: PreviewProvider {
    static var previews: some View {
        TowerEventView(event: TowerEvent(time: 60, towerIndex: 0))
    }
}
