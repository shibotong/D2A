//
//  Provider.swift
//  App
//
//  Created by Shibo Tong on 19/9/21.
//

import WidgetKit
import SwiftUI
import Intents
//import App

struct Provider: IntentTimelineProvider {
    
    typealias Intent = DynamicUserSelectionIntent
    
    public typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), matches: Array(RecentMatch.sample[0...4]), user: UserProfile.empty, subscription: true)
    }

    func getSnapshot(for configuration: DynamicUserSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let user = user(for: configuration)
        guard let firstUser = DotaEnvironment.shared.userIDs.first else {
            let entry = SimpleEntry(date: Date(), matches: [], user: user, subscription: true)
            completion(entry)
            return
        }
        guard let profile = WCDBController.shared.fetchUserProfile(userid: firstUser) else {
            let entry = SimpleEntry(date: Date(), matches: [], user: user, subscription: true)
            completion(entry)
            return
        }
        OpenDotaController.loadRecentMatch(id: "\(profile.id)") { matches in
            let entry = SimpleEntry(date: Date(), matches: matches, user: profile, subscription: true)
            completion(entry)
        }
        
    }

    func getTimeline(for configuration: DynamicUserSelectionIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let currentDate = Date()
        let status = UserDefaults(suiteName: groupName)?.object(forKey: "dotaArmory.subscription") as? Bool ?? false
        if status {
            let selectedProfile = user(for: configuration)
            if selectedProfile.id != 0 {
                OpenDotaController.loadRecentMatch(id: "\(selectedProfile.id)") { matches in
                    let entry = SimpleEntry(date: Date(), matches: matches, user: selectedProfile, subscription: status)
                    let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                }
            } else {
                guard let firstUser = DotaEnvironment.shared.userIDs.first else {
                    let entry = SimpleEntry(date: Date(), matches: [], user: selectedProfile, subscription: status)
                    let refreshDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                    return
                }
                guard let profile = WCDBController.shared.fetchUserProfile(userid: firstUser) else {
                    let entry = SimpleEntry(date: Date(), matches: [], user: selectedProfile, subscription: status)
                    let refreshDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                    return
                }
                OpenDotaController.loadRecentMatch(id: "\(profile.id)") { matches in
                    let entry = SimpleEntry(date: Date(), matches: matches, user: profile, subscription: status)
                    let refreshDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                }
            }
        } else {
            let entry = SimpleEntry(date: Date(), matches: [], user: UserProfile.empty, subscription: status)
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
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
        if entry.subscription {
            if entry.user.id == 0 {
                Text("Select a player").font(.custom(fontString, size: 15))
            } else {
                switch family {
                case .systemSmall:
                    smallView()
                case .systemMedium:
                    mediumView()
                case .systemLarge:
                    largeView()
                default:
                    Text("Not this type of view")
                }
            }
        } else {
            VStack {
                Text("Purchase D2APro to unlock Widget").font(.custom(fontString, size: 15)).bold()
                Text("If you just purchased D2APro, please wait for a while to refresh.").font(.custom(fontString, size: 10))
            }
        }
    }
    
    private func gethero(match: RecentMatch) -> Hero? {
        return HeroDatabase.shared.fetchHeroWithID(id: match.heroID)
    }
    
    @ViewBuilder private func largeView() -> some View {
        VStack(spacing: 5) {
            Link(destination: URL(string: "d2aapp:Match?userid=\(entry.user.id)")!) {
                HStack {
                    NetworkImage(urlString: entry.user.avatarfull).frame(width: 20, height: 20).clipShape(Circle())
                    Text("\(entry.user.personaname)").font(.custom(fontString, size: 13)).bold()
                    Spacer()
                }
            }
            Divider()
            if let match = entry.matches.first {
                Link(destination: URL(string: "d2aapp:Match?userid=\(entry.user.id)&matchid=\(match.id)")!) {
                    buildMatch(match: match)
                }
            }
            Divider()
            if let match = entry.matches[1] {
                Link(destination: URL(string: "d2aapp:Match?userid=\(entry.user.id)&matchid=\(match.id)")!) {
                    buildMatch(match: match)
                }
            }
            Divider()
            if let match = entry.matches[2] {
                Link(destination: URL(string: "d2aapp:Match?userid=\(entry.user.id)&matchid=\(match.id)")!) {
                    buildMatch(match: match)
                }
            }
            Divider()
            if let match = entry.matches[3] {
                Link(destination: URL(string: "d2aapp:Match?userid=\(entry.user.id)&matchid=\(match.id)")!) {
                    buildMatch(match: match)
                }
            }
        }.padding()
    }
    
    @ViewBuilder private func mediumView() -> some View {
        VStack(spacing: 5) {
            Link(destination: URL(string: "d2aapp:Match?userid=\(entry.user.id)")!) {
                HStack {
                    NetworkImage(urlString: entry.user.avatarfull).frame(width: 20, height: 20).clipShape(Circle())
                    Text("\(entry.user.personaname)").font(.custom(fontString, size: 13)).bold()
                    Spacer()
                }
            }
            Divider()
            if let match = entry.matches.first {
                Link(destination: URL(string: "d2aapp:Match?userid=\(entry.user.id)&matchid=\(match.id)")!) {
                    buildMatch(match: match)
                }
            }
            Divider()
            if let match = entry.matches[1] {
                Link(destination: URL(string: "d2aapp:Match?userid=\(entry.user.id)&matchid=\(match.id)")!) {
                    buildMatch(match: match)
                }
            }
        }.padding()
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
    
    // MARK: - Build Match
    @ViewBuilder private func buildMatch(match: RecentMatch) -> some View {
        switch family {
        case .systemSmall:
            // MARK: small
            VStack {
                NetworkImage(urlString: "\(baseURL)\(self.gethero(match: match)?.icon ?? "")")
                    .frame(width: 20, height: 20)
                buildWL(win: match.isPlayerWin())
            }
        case .systemMedium:
            // MARK: medium
            let primaryLabelSize: CGFloat = 17
            let secondaryLabelSize: CGFloat = 14
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    HStack {
                        HeroImageView(localizedName: self.gethero(match: match)?.localizedName ?? "")
                            .frame(width: primaryLabelSize, height: primaryLabelSize)
                        Text(LocalizedStringKey(self.gethero(match: match)?.localizedName ?? "Unknown (\(match.heroID)")).font(.custom(fontString, size: primaryLabelSize)).bold()
                    }
                    
                    HStack {
                        buildWL(win: match.isPlayerWin(), size: secondaryLabelSize)
                        KDAView(kills: match.kills, deaths: match.deaths, assists: match.assists, size: secondaryLabelSize)
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(match.startTime.convertToTime())
                    Text(LocalizedStringKey(match.fetchLobby().fetchLobbyName()))
                        .foregroundColor(match.fetchLobby().fetchLobbyName() == "Ranked" ? Color(.systemYellow) : Color(.secondaryLabel))
                }.font(.custom(fontString, size: secondaryLabelSize)).foregroundColor(Color(.secondaryLabel)).padding(.vertical, 5)
            }
        case .systemLarge:
            // MARK: Large
            let primaryLabelSize: CGFloat = 17
            let secondaryLabelSize: CGFloat = 14
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        HeroImageView(localizedName: self.gethero(match: match)?.localizedName ?? "")
                            .frame(width: primaryLabelSize, height: primaryLabelSize)
                        Text(LocalizedStringKey(self.gethero(match: match)?.localizedName ?? "Unknown Hero \(match.heroID)")).font(.custom(fontString, size: primaryLabelSize)).bold()
                    }
                    HStack {
                        buildWL(win: match.isPlayerWin(), size: secondaryLabelSize)
                        Text("\(match.duration.convertToDuration())").font(.custom(fontString, size: secondaryLabelSize))
                    }
                    HStack {
                        KDAView(kills: match.kills, deaths: match.deaths, assists: match.assists, size: secondaryLabelSize)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text(match.startTime.convertToTime())
                    Text(LocalizedStringKey(match.fetchMode().fetchModeName()))
                    Text(LocalizedStringKey(match.fetchLobby().fetchLobbyName()))
                        .foregroundColor(match.fetchLobby().fetchLobbyName() == "Ranked" ? Color(.systemYellow) : Color(.secondaryLabel))
                }.font(.custom(fontString, size: secondaryLabelSize)).foregroundColor(Color(.secondaryLabel)).padding(.vertical, 5)
            }
        default:
            Text("No this size")
        }
        
    }
    
    @ViewBuilder private func buildWL(win: Bool, size: CGFloat = 15) -> some View {
        ZStack {
            Rectangle().foregroundColor(win ? Color(.systemGreen) : Color(.systemRed))
                .frame(width: size, height: size)
            Text("\(win ? "W" : "L")").font(.custom(fontString, size: 10)).bold().foregroundColor(.white)
        }
    }
}
