//
//  LiveMatchEventRowView.swift
//  D2A
//
//  Created by Shibo Tong on 11/6/2023.
//

import SwiftUI

struct LiveMatchEventRowView: View {
    
    let event: LiveMatchEventItem
    
    var timeLabel: some View {
        Text("\(event.time.toDuration)")
            .font(.caption)
            .foregroundColor(.secondaryLabel)
    }
    
    var icon: some View {
        Image(event.icon)
            .resizable()
            .scaledToFit()
            .frame(width: 30)
            .cornerRadius(5)
    }
    
    var body: some View {
        HStack(alignment: .top) {
            if !event.isRadiantEvent {
                timeLabel
                Spacer()
            }
            if event.isRadiantEvent {
                icon
            }
            VStack(alignment: .leading, spacing: 1) {
                ForEach(event.events) { event in
                    LiveMatchEventDetailView(eventDetail: event)
                }
            }
            if !event.isRadiantEvent {
                icon
            }
            if event.isRadiantEvent {
                Spacer()
                timeLabel
            }
        }
    }
}

struct LiveMatchEventDetailView: View {
    
    let eventDetail: LiveMatchEventDetail
    
    var body: some View {
        HStack(spacing: 5) {
            Text(eventDetail.eventDescription)
            if let itemIcon = eventDetail.itemIcon,
               let itemName = eventDetail.itemName {
                itemIcon
                Text(itemName)
                    .bold()
                    .lineLimit(1)
            }
        }
    }
}

struct LiveMatchEventRowView_Previews: PreviewProvider {
    
    static let buildingEventRadiant = LiveMatchBuildingEvent(indexId: 28, time: 180, type: .case(.tower), isAlive: false, isRadiant: false).generateEvent()
    static let buildingEventDire = LiveMatchBuildingEvent(indexId: 28, time: 180, type: .case(.barracks), isAlive: false, isRadiant: true).generateEvent()
    static let killEvent = LiveMatchKillEvent(time: 100, kill: [1, 2], died: [6, 7], players: .preview).generateEvent()
    static let killEvent2 = LiveMatchKillEvent(time: 100, kill: [1], died: [6, 7, 8, 9, 10], players: .preview, heroDatabase: HeroDatabase.preview).generateEvent()
    static let killEvent3 = LiveMatchKillEvent(time: 100, kill: [7], died: [1, 2, 3, 4, 5], players: .preview, heroDatabase: HeroDatabase.preview).generateEvent()
    
    static var previews: some View {
        VStack {
            ForEach(buildingEventRadiant) { event in
                LiveMatchEventRowView(event: event)
            }
            ForEach(buildingEventDire) { event in
                LiveMatchEventRowView(event: event)
            }
            ForEach(killEvent) { event in
                LiveMatchEventRowView(event: event)
            }
            ForEach(killEvent2) { event in
                LiveMatchEventRowView(event: event)
            }
            ForEach(killEvent3) { event in
                LiveMatchEventRowView(event: event)
            }
        }
        .padding()
        .previewLayout(.fixed(width: 400, height: 100))
    }
}
