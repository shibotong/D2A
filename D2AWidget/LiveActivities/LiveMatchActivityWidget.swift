//
//  LiveMatchActivityWidget.swift
//  D2A
//
//  Created by Shibo Tong on 15/6/2023.
//

import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
@available(iOSApplicationExtension 16.1, *)
struct LiveMatchActivityWidget: Widget {

  private let iconSmallSize: CGFloat = 34
  private let iconExpandSize: CGFloat = 75

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
            LiveMatchActivityTeamIconView(isRadiant: true)
              .frame(width: iconExpandSize)
            Text("\(context.state.radiantScore)")
              .font(.title)
              .bold()
          }
        }
        DynamicIslandExpandedRegion(.trailing) {
          HStack {
            Text("\(context.state.direScore)")
              .font(.title)
              .bold()
            LiveMatchActivityTeamIconView(isRadiant: false)
              .frame(width: iconExpandSize)
          }
        }
        DynamicIslandExpandedRegion(.center) {
          HStack {
            let time = context.state.time
            Image(systemName: time.isDotaDayTime ? "sun.min.fill" : "moon.fill")
              .foregroundColor(time.isDotaDayTime ? .orange : .blue)
            Text("\(context.state.time.toDuration)")
          }
        }

        DynamicIslandExpandedRegion(.bottom) {
          HStack {
            if let leagueName = context.attributes.leagueName {
              let data = UserDefaults(suiteName: GROUP_NAME)?.data(forKey: "liveActivity.league")
              if data != nil {
                Image(uiImage: UIImage(data: data!)!)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(height: 20)
                  .cornerRadius(5)
              }
              Text(leagueName)
                .font(.caption)
                .lineLimit(1)
            }
          }
        }
      } compactLeading: {
        HStack {
          LiveMatchActivityTeamIconView(isRadiant: true)
          Text("\(context.state.radiantScore)")
        }
      } compactTrailing: {
        HStack {
          Text("\(context.state.direScore)")
          LiveMatchActivityTeamIconView(isRadiant: false)
        }
      } minimal: {
        Text("minimal")
      }
    }
  }
}

struct LiveMatchActivityTeamIconView: View {
  let isRadiant: Bool

  private var key: String {
    isRadiant ? "liveActivity.radiantTeam" : "liveActivity.direTeam"
  }

  private var iconName: String {
    isRadiant ? "icon_radiant" : "icon_dire"
  }

  var body: some View {
    ZStack {
      let data = UserDefaults(suiteName: GROUP_NAME)?.data(forKey: key)
      if data != nil {
        Image(uiImage: UIImage(data: data!)!)
          .resizable()
          .aspectRatio(contentMode: .fit)
      } else {
        Image(iconName)
          .resizable()
          .scaledToFit()
      }
    }
    .clipShape(Circle())
  }
}

@available(iOS 16.1, *)
struct LockScreenLiveActivityView: View {

  let context: ActivityViewContext<LiveMatchActivityAttributes>

  var body: some View {
    VStack {
      if let leagueName = context.attributes.leagueName,
        let data = UserDefaults(suiteName: GROUP_NAME)?.data(forKey: "liveActivity.league")
      {
        HStack {
          Image(uiImage: UIImage(data: data)!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 20)
            .cornerRadius(5)
          Text(leagueName)
            .font(.caption)
            .lineLimit(1)
        }
      }

      HStack {
        LiveMatchActivityTeamIconView(isRadiant: true)
        Text(context.state.radiantScore.description)
        VStack {
          let time = context.state.time
          Image(systemName: time.isDotaDayTime ? "sun.min.fill" : "moon.fill")
            .foregroundColor(time.isDotaDayTime ? .orange : .blue)
          Text("\(context.state.time.toDuration)")
        }
        Text(context.state.direScore.description)
        LiveMatchActivityTeamIconView(isRadiant: false)
      }
    }
    .padding()
  }
}

@available(iOS 16.2, *)
@available(iOSApplicationExtension 16.2, *)
struct LiveMatchActivityWidget_Previews: PreviewProvider {
  static let activityState = LiveMatchActivityAttributes.ContentState(
    radiantScore: 0, direScore: 0, time: 0)

  static let activityAttributes = LiveMatchActivityAttributes()

  static var previews: some View {
    activityAttributes
      .previewContext(activityState, viewKind: .content)
      .previewDisplayName("Notification")

    activityAttributes
      .previewContext(activityState, viewKind: .dynamicIsland(.compact))
      .previewDisplayName("Compact")

    activityAttributes
      .previewContext(activityState, viewKind: .dynamicIsland(.expanded))
      .previewDisplayName("Expanded")

    activityAttributes
      .previewContext(activityState, viewKind: .dynamicIsland(.minimal))
      .previewDisplayName("Minimal")

  }
}
