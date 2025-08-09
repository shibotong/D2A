//
//  LiveMatchEventListView.swift
//  D2A
//
//  Created by Shibo Tong on 11/6/2023.
//

import SwiftUI

struct LiveMatchEventListView: View {

    var events: [any LiveMatchEvent]

    var latestEventTime5Minute: Int {
        guard let latestEvent = events.first else {
            return 0
        }
        return latestEvent.time / 300 + 1
    }

    var body: some View {
        VStack {
            ForEach(0...latestEventTime5Minute, id: \.self) { each5Mins in
                let seconds = (latestEventTime5Minute - each5Mins) * 300
                buildTimeSection(time: seconds)
            }
            Spacer()
                .frame(height: 200)
        }
    }

    @ViewBuilder
    private func buildTimeSection(time: Int) -> some View {
        let events = self.events.filter { $0.time <= time && $0.time > time - 300 }
        VStack {
            HStack {
                Rectangle()
                    .frame(height: 1)
                Text(time == 0 ? "Pre-match" : "\(time.toDuration)")
                Rectangle()
                    .frame(height: 1)
            }
            .foregroundColor(.secondaryLabel)
            ForEach(events, id: \.id) { event in
                let generateEvents = event.generateEvent()
                ForEach(generateEvents) { generateEvent in
                    LiveMatchEventRowView(event: generateEvent).listRowSeparator(.hidden)
                }
            }
        }
    }
}

// struct LiveMatchEventListView_Previews: PreviewProvider {
//
//    static let buildingEvent = LiveMatchBuildingEvent(indexId: 28, time: 180, type: .case(.tower), isAlive: false, isRadiant: false)
//    static let killEvent = LiveMatchKillEvent(time: 100, kill: [1], died: [6, 7, 8, 9, 10], players: .preview, ConstantsController: ConstantsController(heroes: loadSampleHero()!))
//
//    static var previews: some View {
//        LiveMatchEventListView(events: [buildingEvent, killEvent])
//    }
// }
