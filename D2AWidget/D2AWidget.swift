//
//  D2AWidget.swift
//  D2AWidget
//
//  Created by Shibo Tong on 18/9/21.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct D2AWidget: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        RecentMatchesWidget()
        LatestMatchWidget()
    }
}


struct RecentMatchesWidget: Widget {
    let kind: String = "D2AWidget"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicUserSelectionIntent.self, provider: Provider()) { entry in
//            RecentMatchesEntryView(entry: entry)
            RecentMatchesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Recent Matches")
        .description("Your recent matches.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct LatestMatchWidget: Widget {
    let kind: String = "LatestWidget"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicUserSelectionIntent.self, provider: Provider()) { entry in
//            RecentMatchesEntryView(entry: entry)
            LatestMatchWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Latest Match")
        .description("Your latest match.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        
    }
}



struct SimpleEntry: TimelineEntry {
    let date: Date
    let matches: [RecentMatch]
    let user: UserProfile?
    let subscription: Bool
}


