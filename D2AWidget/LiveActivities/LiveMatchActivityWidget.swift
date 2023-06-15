//
//  LiveMatchActivityWidget.swift
//  D2A
//
//  Created by Shibo Tong on 15/6/2023.
//

import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
struct LiveMatchActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveMatchActivityAttributes.self) { context in
            // Create the presentation that appears on the Lock Screen and as a
            // banner on the Home Screen of devices that don't support the
            // Dynamic Island.
            // ...
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            // Create the presentations that appear in the Dynamic Island.

            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        LiveMatchTeamIconView(url: context.state.radiantTeam, isRadiant: true)
                        Text("\(context.state.radiantScore)")
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Text("\(context.state.direScore)")
                        LiveMatchTeamIconView(url: context.state.direTeam, isRadiant: false)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack {
                        let time = context.state.time
                        Image(systemName: time.isDotaDayTime ? "sun.min.fill" : "moon.fill")
                            .foregroundColor(time.isDotaDayTime ? .orange : .blue)
                        Text("\(context.state.time.toDuration)")
                    }
                }
            } compactLeading: {
                HStack {
                    LiveMatchTeamIconView(url: context.state.radiantTeam, isRadiant: true)
                    Text("\(context.state.radiantScore)")
                }
            } compactTrailing: {
                HStack {
                    Text("\(context.state.direScore)")
                    LiveMatchTeamIconView(url: context.state.direTeam, isRadiant: false)
                }
            } minimal: {
                Text("minimal")
            }
        }
    }
}

@available(iOS 16.1, *)
struct LockScreenLiveActivityView: View {

    let context: ActivityViewContext<LiveMatchActivityAttributes>
    
    var body: some View {
        VStack {
            Text("Dyanmic String: (context.state.dynamicStringValue))")
            Text("Static String: (context.staticStringValue))")
        }
        .activitySystemActionForegroundColor(.indigo)
        .activityBackgroundTint(.cyan)
    }
}
