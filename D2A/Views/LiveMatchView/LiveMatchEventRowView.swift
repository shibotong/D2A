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
