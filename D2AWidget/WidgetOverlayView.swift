//
//  SubscriptionWidgetView.swift
//  AppWidgetExtension
//
//  Created by Shibo Tong on 23/6/2022.
//

import SwiftUI
import WidgetKit

enum WidgetOverlayType {
    case subscription
    case chooseProfile
}

struct WidgetOverlayView: View {
    
    @Environment(\.widgetFamily) var family

    var widgetType: WidgetOverlayType
    
    private var widgetTitle: String {
        switch self.widgetType {
        case .subscription:
            return "D2A Pro"
        case .chooseProfile:
            return "No Profile"
        }
    }

    private var widgetSubtitle: String {
        switch self.widgetType {
        case .subscription:
            return "Purchase D2A Pro to unlock Widget"
        case .chooseProfile:
            return "Long press Widget and select a Profile"
        }
    }

    private var iconString: String {
        switch self.widgetType {
        case .subscription:
            return "cart"
        case .chooseProfile:
            return "person.fill"
        }
    }

    @ViewBuilder var mainView: some View {
        switch self.family {
        case .systemSmall, .systemMedium:
            GeometryReader { proxy in
                let avatarSize = { () -> CGFloat in
                    switch self.family {
                    case .systemSmall:
                        return proxy.size.height / 3
                    case .systemMedium:
                        return proxy.size.height * 3 / 7
                    case .systemLarge:
                        return proxy.size.height
                    default:
                        return proxy.size.height
                    }
                }()
                VStack(spacing: 0) {
                    buildSubscriptionTitle(avatarSize: avatarSize)
                        .frame(height: proxy.size.height / 2)
                    Text(widgetSubtitle)
                        .font(.caption)
                        .frame(height: proxy.size.height / 2)
                }
            }.padding()
        case .systemLarge:
            VStack(spacing: 20) {
                VStack {
                    ZStack {
                        Circle().foregroundColor(Color.primaryDota)
                        Image(systemName: iconString)
                            .resizable()
                            .scaledToFit()
                            .padding(20)
                            .foregroundColor(.white)
                    }.frame(width: 80, height: 80)
                    Text(widgetTitle)
                        .font(.caption)
                        .bold()

                }
                Text(widgetSubtitle)
                    .font(.caption)
            }
        default:
            EmptyView()
        }
    }

    var body: some View {
        ZStack {
            if self.widgetType == .subscription {
                Link(destination: URL(string: "d2aapp:purchase?purchase=true")!) {
                    mainView
                }
            } else {
                mainView
            }
        }
    }
    
    @ViewBuilder private func buildSubscriptionTitle(avatarSize: CGFloat) -> some View {
        switch self.family {
        case .systemSmall:
            VStack {
                ZStack {
                    Circle().foregroundColor(Color.primaryDota)
                    Image(systemName: iconString)
                        .resizable()
                        .scaledToFit()
                        .padding(avatarSize / 4.0)
                        .foregroundColor(.white)
                }.frame(width: avatarSize, height: avatarSize)
                Text(widgetTitle)
                    .font(.caption)
                    .bold()
            }
            .frame(maxWidth: .infinity)
        case .systemMedium:
            HStack {
                ZStack {
                    Circle().foregroundColor(Color.primaryDota)
                    Image(systemName: iconString)
                        .resizable()
                        .scaledToFit()
                        .padding(avatarSize / 4.0)
                        .foregroundColor(.white)
                }.frame(width: avatarSize, height: avatarSize)
                VStack(alignment: .leading) {
                    Text(widgetTitle)
                        .font(.caption)
                        .bold()
                }
                Spacer()
            }
        case .systemLarge:
            VStack {
                ZStack {
                    Circle().foregroundColor(Color.primaryDota)
                    Image(systemName: iconString)
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                        .foregroundColor(.white)
                }.frame(width: 80, height: 80)
                Text(widgetTitle)
                    .font(.caption)
                    .bold()
            }
        default:
            EmptyView()
        }
    }
}

struct SubscriptionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetOverlayView(widgetType: .chooseProfile)
//                .environment(\.widgetFamily, .systemSmall)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            WidgetOverlayView(widgetType: .chooseProfile)
//                .environment(\.widgetFamily, .systemMedium)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            WidgetOverlayView(widgetType: .subscription)
//                .environment(\.widgetFamily, .systemLarge)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
