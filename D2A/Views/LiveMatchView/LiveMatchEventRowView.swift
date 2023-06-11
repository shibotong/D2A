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
        HStack {
            if !event.isRadiantEvent {
                timeLabel
                Spacer()
            }
            if event.isRadiantEvent {
                icon
            }
            VStack {
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
            if let eventIcon = eventDetail.eventIcon {
                eventIcon
            }
            Text(eventDetail.eventDescription)
            if let itemIcon = eventDetail.itemIcon,
               let itemName = eventDetail.itemName {
                itemIcon
                Text(itemName)
                    .bold()
            }
        }
    }
}

struct LiveMatchEventRowView_Previews: PreviewProvider {
    
    static let buildingEvent = LiveMatchBuildingEvent(indexId: 28, time: 180, type: .case(.tower), isAlive: false, xPos: 160, yPos: 156, isRadiant: false).generateEvent()
    
    static var previews: some View {
        VStack {
            ForEach(buildingEvent) { event in
                LiveMatchEventRowView(event: event)
            }
        }
        .previewLayout(.fixed(width: 400, height: 100))
    }
}
