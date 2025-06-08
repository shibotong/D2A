//
//  D2AWidget.swift
//  D2AWidget
//
//  Created by Shibo Tong on 18/9/21.
//

import SwiftUI
import WidgetKit

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
    IntentConfiguration(kind: kind, intent: DynamicUserSelectionIntent.self, provider: Provider()) {
      entry in
      RecentMatchesWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Recent Matches")
    .description("Your recent matches.")
    .supportedFamilies([.systemSmall, .systemMedium])
    //        .containerBackgroundRemovable(true)

  }
}

struct LatestMatchWidget: Widget {
  let kind: String = "LatestWidget"
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: DynamicUserSelectionIntent.self, provider: Provider()) {
      entry in
      LatestMatchWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Latest Match")
    .description("Your latest match.")
    .supportedFamilies([.systemMedium, .systemLarge])
    //        .containerBackgroundRemovable(true)
    .contentMarginsDisabled()

  }
}
