//
//  LatestMatchWidgetEntryView.swift
//  App
//
//  Created by Shibo Tong on 17/6/2022.
//

import SwiftUI
import WidgetKit

struct LatestMatchWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    private let avatarHeight: CGFloat = 20

    var maxMatches: Int {
        switch self.family {
        case .systemMedium:
            return 2
        case .systemLarge:
            return 5
        default:
            return 1
        }
    }

    private var matches: [D2AWidgetMatch] {
        guard let matches = entry.user?.matches else {
            return []
        }
        guard matches.count <= maxMatches else {
            return Array(matches[0..<maxMatches])
        }
        return matches
    }

    var body: some View {
        ZStack {
            switch family {
            case .systemMedium, .systemLarge:
                mediumView
                    .blur(radius: entry.subscription ? 0 : 15)
            default:
                EmptyView()
            }
            if !entry.subscription {
                WidgetOverlayView(widgetType: .subscription)
            }
        }
        .widgetBackground(Color.systemBackground)
    }

    private var mediumView: some View {
        ZStack {
            if let user = entry.user {
                VStack(spacing: 0) {
                    Link(
                        destination: URL(string: "d2aapp:profile?userid=\(user.userID)")!,
                        label: {
                            HStack {
                                Image(uiImage: user.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: avatarHeight)
                                    .clipShape(Circle())
                                Text(user.userName)
                                    .font(.caption2)
                                    .bold()
                                Spacer()
                                Text(user.userID)
                                    .font(.caption2)
                                    .foregroundColor(.secondaryLabel)
                            }
                            .padding(10)
                        })
                    GeometryReader { proxy in
                        VStack(spacing: 0) {
                            ForEach(matches) { match in
                                Divider()
                                MatchListRowView(viewModel: MatchListRowViewModel(match: match))
                                    .frame(height: proxy.size.height / CGFloat(maxMatches))
                            }
                        }
                    }
                }
            } else {
                WidgetOverlayView(widgetType: .chooseProfile)
            }
        }
    }
}

struct LatestMatchWidgetEntryView_Previews: PreviewProvider {
    static let widgetFamilies: [WidgetFamily] = [.systemMedium, .systemLarge]
    static var previews: some View {
        ForEach(widgetFamilies, id: \.rawValue) { family in
            LatestMatchWidgetEntryView(entry: D2AWidgetUserEntry.preview)
                .previewContext(WidgetPreviewContext(family: family))
        }

    }
}
