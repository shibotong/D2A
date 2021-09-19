//
//  Provider.swift
//  App
//
//  Created by Shibo Tong on 19/9/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    typealias Intent = DynamicUserSelectionIntent
    
    public typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), matches: Array(RecentMatch.sample[0...4]), user: UserProfile.empty)
    }

    func getSnapshot(for configuration: DynamicUserSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        guard let firstUser = DotaEnvironment.shared.userIDs.first else {
            let entry = SimpleEntry(date: Date(), matches: [], user: UserProfile.empty)
            completion(entry)
            return
        }
        guard let profile = WCDBController.shared.fetchUserProfile(userid: firstUser) else {
            let entry = SimpleEntry(date: Date(), matches: [], user: UserProfile.empty)
            completion(entry)
            return
        }
        OpenDotaController.loadRecentMatch(id: "\(profile.id)") { matches in
            let entry = SimpleEntry(date: Date(), matches: matches, user: profile)
            completion(entry)
        }
        
    }

    func getTimeline(for configuration: DynamicUserSelectionIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        if DotaEnvironment.shared.subscriptionStatus {
            let selectedProfile = user(for: configuration)
            if selectedProfile.id != 0 {
                OpenDotaController.loadRecentMatch(id: "\(selectedProfile.id)") { matches in
                    var entries: [SimpleEntry] = []
                    for i in 0...4 {
                        let entry = SimpleEntry(date: Date().addingTimeInterval(TimeInterval(3600 * i)), matches: matches, user: selectedProfile)
                        entries.append(entry)
                    }
                    let timeline = Timeline(entries: entries, policy: .atEnd)
                    completion(timeline)
                }
            } else {
                let entry = SimpleEntry(date: Date(), matches: [], user: selectedProfile)
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        } else {
            var entries: [SimpleEntry] = []
            for i in 0...10 {
                let entry = SimpleEntry(date: Date().addingTimeInterval(TimeInterval(300 * i)), matches: [], user: UserProfile.empty)
                entries.append(entry)
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
    }
    
    func user(for configuration: DynamicUserSelectionIntent) -> UserProfile {
        if let id = configuration.profile?.identifier {
            if let profile = WCDBController.shared.fetchUserProfile(userid: id) {
                return profile
            } else {
                return UserProfile.empty
            }
        } else {
            return UserProfile.empty
        }
    }
}

struct AppActiveWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        if DotaEnvironment.shared.subscriptionStatus {
            if entry.user.id == 0 {
                Text("Select a player").font(.custom(fontString, size: 15))
            } else {
                switch family {
                case .systemSmall:
                    smallView()
                case .systemMedium:
                    mediumView()
                case .systemLarge:
                    Text("Not provide large Widget")
                @unknown default:
                    Text("Cannot identify which size of widget")
                }
            }
        } else {
            VStack {
                Text("Subscribe D2APlus to unlock Widget").font(.custom(fontString, size: 15)).bold()
                Text("If you just subscribe D2APlus, please wait for a while to refresh.").font(.custom(fontString, size: 10))
            }
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
