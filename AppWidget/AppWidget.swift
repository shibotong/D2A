//
//  AppWidget.swift
//  AppWidget
//
//  Created by Shibo Tong on 18/9/21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), matches: Array(RecentMatch.sample[0...4]), user: SteamProfile.sample)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), matches: Array(RecentMatch.sample[0...4]), user: SteamProfile.sample)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        
        OpenDotaController.loadRecentMatch { matches, profile in
            let entry = SimpleEntry(date: Date(), matches: matches, user: profile)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let matches: [RecentMatch]
    let user: SteamProfile
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
                        NetworkImage(urlString: entry.user.profile.avatarfull).frame(width: 80, height: 80).clipShape(Circle())
                        Text("\(entry.user.profile.personaname)").font(.custom(fontString, size: 13))
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
            NetworkImage(urlString: entry.user.profile.avatarfull).blur(radius: 25)
            VStack {
                VStack {
                    NetworkImage(urlString: entry.user.profile.avatarfull).frame(width: 40, height: 40).clipShape(Circle())
                    Text("\(entry.user.profile.personaname)").font(.custom(fontString, size: 13))
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
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
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
            AppWidgetEntryView(entry: SimpleEntry(date: Date(), matches: Array(RecentMatch.sample[0...4]), user: SteamProfile.sample))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            AppWidgetEntryView(entry: SimpleEntry(date: Date(), matches: Array(RecentMatch.sample[0...4]), user: SteamProfile.sample))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
