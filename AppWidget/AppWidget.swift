//
//  AppWidget.swift
//  AppWidget
//
//  Created by Shibo Tong on 18/9/21.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct AppWidget: Widget {
    let kind: String = "AppWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicUserSelectionIntent.self, provider: Provider()) { entry in
            AppActiveWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Recent Matches")
        .description("Your recent matches.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let matches: [RecentMatch]
    let user: UserProfile
    let subscription: Bool
}

struct AppWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppActiveWidgetEntryView(entry: SimpleEntry(date: Date(), matches: Array(RecentMatch.sample[0...4]), user: SteamProfile.sample.profile, subscription: true))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            AppActiveWidgetEntryView(entry: SimpleEntry(date: Date(), matches: Array(RecentMatch.sample[0...4]), user: SteamProfile.sample.profile, subscription: true))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
