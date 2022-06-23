//
//  SubscriptionWidgetView.swift
//  AppWidgetExtension
//
//  Created by Shibo Tong on 23/6/2022.
//

import SwiftUI
import WidgetKit

struct SubscriptionWidgetView: View {
    
    @Environment(\.widgetFamily) var family
    
    private let purchaseTitle = "D2A Pro"
    private let purchaseSubTitle = "Purchase D2A Pro to unlock Widget"
    
    private let selectUserTitle = "No Profile"
    private let selectUserSubTitle = "Please select a Profile"
    
    var body: some View {
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
                    Text(purchaseSubTitle)
                        .font(.caption)
                        .frame(height: proxy.size.height / 2)
                        
                }
            }.padding()
        case .systemLarge:
            VStack(spacing: 20) {
                VStack {
                    ZStack {
                        Circle().foregroundColor(Color.primaryDota)
                        Image(systemName: "cart")
                            .resizable()
                            .scaledToFit()
                            .padding(20)
                            .foregroundColor(.white)
                    }.frame(width: 80, height: 80)
                    Text(purchaseTitle)
                        .font(.caption)
                        .bold()
          
                }
                Text(purchaseSubTitle)
                    .font(.caption)
            }
        default:
            EmptyView()
        }
        
    }
    
    @ViewBuilder private func buildSubscriptionTitle(avatarSize: CGFloat) -> some View {
        switch self.family {
        case .systemSmall:
            VStack {
                ZStack {
                    Circle().foregroundColor(Color.primaryDota)
                    Image(systemName: "cart")
                        .resizable()
                        .scaledToFit()
                        .padding(avatarSize / 4.0)
                        .foregroundColor(.white)
                }.frame(width: avatarSize, height: avatarSize)
                Text(purchaseTitle)
                    .font(.caption)
                    .bold()
            }
        case .systemMedium:
            HStack {
                ZStack {
                    Circle().foregroundColor(Color.primaryDota)
                    Image(systemName: "cart")
                        .resizable()
                        .scaledToFit()
                        .padding(avatarSize / 4.0)
                        .foregroundColor(.white)
                }.frame(width: avatarSize, height: avatarSize)
                VStack(alignment: .leading) {
                    Text(purchaseTitle)
                        .font(.caption)
                        .bold()
                }
                Spacer()
            }
        case .systemLarge:
            VStack {
                ZStack {
                    Circle().foregroundColor(Color.primaryDota)
                    Image(systemName: "cart")
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                        .foregroundColor(.white)
                }.frame(width: 80, height: 80)
                Text(purchaseTitle)
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
            SubscriptionWidgetView()
//                .environment(\.widgetFamily, .systemSmall)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            SubscriptionWidgetView()
//                .environment(\.widgetFamily, .systemMedium)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            SubscriptionWidgetView()
//                .environment(\.widgetFamily, .systemLarge)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .previewDevice(iPodTouch)
        }
    }
}
