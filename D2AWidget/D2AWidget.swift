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
        
        if #available(iOS 16.1, *) {
            LiveMatchActivityWidget()
        }
    }
}

struct RecentMatchesWidget: Widget {
    let kind: String = "D2AWidget"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicUserSelectionIntent.self, provider: Provider()) { entry in
            RecentMatchesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Recent Matches")
        .description("Your recent matches.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .containerBackgroundRemovable(true)
    }
}

struct LatestMatchWidget: Widget {
    let kind: String = "LatestWidget"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicUserSelectionIntent.self, provider: Provider()) { entry in
            LatestMatchWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Latest Match")
        .description("Your latest match.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .containerBackgroundRemovable(true)
        
    }
}

struct D2AWidgetUserEntry: TimelineEntry {
    let date: Date
    let user: D2AWidgetUser?
}

struct D2AWidgetUser {
    let userID: String
    let userName: String
    let image: UIImage?
    let matches: [RecentMatch]
    let subscription: Bool
    
    static let sampleUser = D2AWidgetUser(userID: "1234567", userName: "Test User", image: UIImage(named: "profile") ?? nil, matches: [], subscription: true)
}
