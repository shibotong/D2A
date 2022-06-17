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
            RecentMatchesEntryView(entry: entry)
//            RecentMatchesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Recent Matches")
        .description("Your recent matches.")
        .supportedFamilies([.systemSmall, .systemMedium])
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let matches: [RecentMatch]
    let user: UserProfile
    let subscription: Bool
}


