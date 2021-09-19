//
//  AppWidget.swift
//  AppWidget
//
//  Created by Shibo Tong on 18/9/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    typealias Intent = DynamicUserSelectionIntent
    
    public typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), matches: Array(RecentMatch.sample[0...4]), user: SteamProfile.sample.profile)
    }

    func getSnapshot(for configuration: DynamicUserSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), matches: Array(RecentMatch.sample[0...4]), user: SteamProfile.sample.profile)
        completion(entry)
    }

    func getTimeline(for configuration: DynamicUserSelectionIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        
        let selectedProfile = user(for: configuration)
        
        OpenDotaController.loadRecentMatch(id: "\(selectedProfile.id)") { matches in
            let entry = SimpleEntry(date: Date(), matches: matches, user: selectedProfile)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
    
    func user(for configuration: DynamicUserSelectionIntent) -> UserProfile {
        if let id = configuration.profile?.identifier {
            if let profile = WCDBController.shared.fetchUserProfile(userid: id) {
                return profile
            } else {
                return SteamProfile.sample.profile
            }
        } else {
            return SteamProfile.sample.profile
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let matches: [RecentMatch]
    let user: UserProfile
}

struct AppWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            smallView()
        case .systemMedium:
            mediumView()
        case .systemLarge:
            Text("123")
        @unknown default:
            Text("123")
        }
    }
    
    private func gethero(match: RecentMatch) -> Hero {
        return HeroDatabase.shared.fetchHeroWithID(id: match.heroID)!
    }
    
    @ViewBuilder private func mediumView() -> some View {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    VStack {
                        NetworkImage(urlString: entry.user.avatarfull).frame(width: 80, height: 80).clipShape(Circle())
                        Text("\(entry.user.personaname)").font(.custom(fontString, size: 13))
                    }.frame(width: geo.size.width / 2)
                    VStack(spacing: 10) {
                        ForEach(entry.matches, id:\.id) { match in
                            buildMatch(match: match)
                        }
                    }.frame(width: geo.size.width / 2)
                }.padding()
            }

    }
    
    @ViewBuilder private func smallView() -> some View {
        ZStack {
            NetworkImage(urlString: entry.user.avatarfull).blur(radius: 25)
            VStack {
                VStack {
                    NetworkImage(urlString: entry.user.avatarfull).frame(width: 40, height: 40).clipShape(Circle())
                    Text("\(entry.user.personaname)").font(.custom(fontString, size: 13))
                }
                HStack {
                    ForEach(entry.matches, id:\.id) { match in
                        buildMatch(match: match)
                    }
                }
            }.padding()
        }
    }
    
    @ViewBuilder private func buildMatch(match: RecentMatch) -> some View {
        switch family {
        case .systemSmall:
            VStack {
                NetworkImage(urlString: "\(baseURL)\(self.gethero(match: match).icon)")
                    .frame(width: 20, height: 20)
                buildWL(win: match.isPlayerWin())
            }
        case .systemMedium:
            HStack {
                buildWL(win: match.isPlayerWin())
                NetworkImage(urlString: "\(baseURL)\(self.gethero(match: match).icon)")
                    .frame(width: 20, height: 20)
                Text("\(self.gethero(match: match).localizedName)").font(.custom(fontString, size: 13))
                Spacer()
            }
        case .systemLarge:
            Text("123")
        @unknown default:
            Text("123")
        }
        
    }
    
    @ViewBuilder private func buildWL(win: Bool) -> some View {
        ZStack {
            Rectangle().foregroundColor(win ? Color(.systemGreen) : Color(.systemRed))
                .frame(width: 15, height: 15)
            Text("\(win ? "W" : "L")").font(.custom(fontString, size: 10)).bold().foregroundColor(.white)
        }
    }
}

@main
struct AppWidget: Widget {
    let kind: String = "AppWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicUserSelectionIntent.self, provider: Provider()) { entry in
            AppWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Recent Matches")
        .description("Your recent matches.")
        .supportedFamilies([.systemSmall, .systemMedium])
        
    }
}

struct AppWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppWidgetEntryView(entry: SimpleEntry(date: Date(), matches: Array(RecentMatch.sample[0...4]), user: SteamProfile.sample.profile))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            AppWidgetEntryView(entry: SimpleEntry(date: Date(), matches: Array(RecentMatch.sample[0...4]), user: SteamProfile.sample.profile))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
