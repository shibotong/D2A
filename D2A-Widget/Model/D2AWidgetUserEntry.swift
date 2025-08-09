//
//  D2AWidgetUserEntry.swift
//  D2A
//
//  Created by Shibo Tong on 26/1/2024.
//

import WidgetKit

struct D2AWidgetUserEntry: TimelineEntry {
    let date: Date
    let user: D2AWidgetUser?
    let subscription: Bool

    static let preview = D2AWidgetUserEntry(
        date: Date(), user: D2AWidgetUser.preview, subscription: true)
}
