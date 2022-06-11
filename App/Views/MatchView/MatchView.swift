//
//  MatchView.swift
//  App
//
//  Created by Shibo Tong on 12/8/21.
//

import SwiftUI
//import SDWebImageSwiftUI

struct MatchView: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var data: HeroDatabase
    @StateObject var vm: MatchViewModel
    var body: some View {
        buildStack()
            .task {
                await vm.loadMatch()
            }
    }
    
    @ViewBuilder private func buildStack() -> some View {
        if vm.match != nil {
            List {
                buildMatchData()
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                AllTeamPlayerView(match: vm.match!)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                AnalysisView(vm: AnalysisViewModel(player: vm.match!.players))
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                if vm.match!.goldDiff != nil {
                    DifferenceGraphView(vm: DifferenceGraphViewModel(goldDiff: vm.match!.goldDiff, xpDiff: vm.match!.xpDiff))
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                        .frame(height: 300)
                }
            }
            .listStyle(.plain)
            .navigationTitle("ID: \(vm.id ?? "")")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await vm.refreshMatch()
            }
        } else {
            Text("loading...")
        }
    }
    
    @ViewBuilder private func buildMatchData() -> some View {
        VStack(spacing: 30) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    MatchStatCardView(icon: "calendar", title: "Start Time", label: vm.match!.startTime.convertToTime())
                        .frame(width: 140)
                    MatchStatCardView(icon: "clock", title: "Duration", label: "\(vm.match!.duration.convertToDuration())").colorInvert()
                        .frame(width: 140)
                    MatchStatCardView(icon: "rosette", title: "Game Mode", label: LocalizedStringKey(data.fetchGameMode(id: vm.match!.mode).fetchModeName()))
                        .frame(width: 140)
                    MatchStatCardView(icon: "mappin.and.ellipse", title: "Region", label: vm.fetchGameRegion(id: "\(vm.match!.region)"))
                        .colorInvert()
                        .frame(width: 140)
                }.padding(.horizontal)
            }
        }.padding([.top])
    }
}

struct MatchStatCardView: View {
    var icon: String
    var title: LocalizedStringKey
    var label: LocalizedStringKey
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15.0).foregroundColor(Color(.secondarySystemBackground))
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Image(systemName: icon).font(.title)
                    Spacer()
                    Text(title).font(.custom(fontString, size: 10)).foregroundColor(Color(.secondaryLabel))
                    Text(label).font(.custom(fontString, size: 15)).bold().lineLimit(2)
                }
                Spacer()
            }.padding(18)
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        //        NavigationView {
        MatchView(vm: MatchViewModel())
        //        }
            .environmentObject(HeroDatabase.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
        
    }
}

struct AllTeamPlayerView: View {
    var match: Match
    @State var selectedPlayer: Player?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        if horizontalSizeClass == .compact {
            VStack(alignment: .leading, spacing: 0) {
                Text("Players").font(.custom(fontString, size: 20)).bold().padding([.horizontal, .top])
                TeamView(players: match.fetchPlayers(isRadiant: true), isRadiant: true, score: match.fetchKill(isRadiant: true), win: match.radiantWin, maxDamage: fetchMaxDamage(players: match.players))
                TeamView(players: match.fetchPlayers(isRadiant: false), isRadiant: false, score: match.fetchKill(isRadiant: false), win: !match.radiantWin, maxDamage: fetchMaxDamage(players: match.players))
            }
            .frame(minWidth: 300)
        } else {
            VStack(alignment: .leading, spacing: 0) {
                Text("Players").font(.custom(fontString, size: 20)).bold().padding([.horizontal, .top])
                HStack {
                    TeamView(players: match.fetchPlayers(isRadiant: true), isRadiant: true, score: match.fetchKill(isRadiant: true), win: match.radiantWin, maxDamage: fetchMaxDamage(players: match.players))
                    TeamView(players: match.fetchPlayers(isRadiant: false), isRadiant: false, score: match.fetchKill(isRadiant: false), win: !match.radiantWin, maxDamage: fetchMaxDamage(players: match.players))
                }
            }
            .frame(minWidth: 300)
        }
    }
    
    func fetchMaxDamage(players: [Player]) -> Int {
        if players.first!.heroDamage != nil {
            let sortedPlayers = players.sorted(by: { $0.heroDamage ?? 0 > $1.heroDamage ?? 0})
            return sortedPlayers.first!.heroDamage!
        } else {
            return 0
        }
    }
}

struct DifferenceView: View {
    var body: some View {
        ZStack {
            VStack {
                Rectangle().frame(height: 1)
                Spacer()
                Rectangle().frame(height: 1)
                Spacer()
                Rectangle().frame(height: 1)
            }
        }
    }
}

struct PlayerRowView: View {
    var player: Player
    var isRadiant: Bool
    @EnvironmentObject var env: DotaEnvironment
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var showPlayer = false
    var maxDamage: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HeroImageView(heroID: player.heroID, type: .icon)
                    .frame(width: 35, height: 35)
                    .overlay(HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Circle()
                                .frame(width: 15, height: 15)
                                .overlay(Text("\(player.level)")
                                            .foregroundColor(Color(.systemBackground))
                                            .font(.custom(fontString, size: 8)).bold())
                        }
                    })
                VStack(alignment: .leading, spacing: 2) {
                    if player.personaname != nil {
                        HStack(spacing: 2) {
                            Image("rank_\((player.rank ?? 0) / 10)").resizable().frame(width: 18, height: 18)
                            Text(player.personaname!).font(.custom(fontString, size: 15)).bold().lineLimit(1)
                        }
                    } else {
                        Text("Anonymous").font(.custom(fontString, size: 15)).bold().lineLimit(1)
                    }
                    KDAView(kills: player.kills, deaths: player.deaths, assists: player.assists, size: 13)
                }.frame(minWidth: 0)
                Spacer()
                if let item = player.itemNeutral {
                    ItemView(id: item)
                        .frame(width: 24, height: 18)
                        .clipShape(Circle())
                        .frame(width: 8)
                }
                VStack(spacing: 1) {
                    HStack(spacing: 1) {
//                        Spacer().frame(width: 18)
                        ItemView(id: player.item0).frame(width: 24, height: 18)
                        ItemView(id: player.item1).frame(width: 24, height: 18)
                        ItemView(id: player.item2).frame(width: 24, height: 18)
                    }
                    HStack(spacing: 1) {
                        ItemView(id: player.item3).frame(width: 24, height: 18)
                        ItemView(id: player.item4).frame(width: 24, height: 18)
                        ItemView(id: player.item5).frame(width: 24, height: 18)
                    }
                }
                VStack(spacing: 0) {
                    Image("scepter_\(player.hasScepter() ? "1" : "0")")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        
                    Image("shard_\(player.hasShard() ? "1" : "0")")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 12)
                }.frame(width: 10)
                VStack(spacing: 0) {
                    HStack(spacing: 3) {
                        Circle().frame(width: 8, height: 8).foregroundColor(Color(.systemYellow))
                        Text("\(player.gpm)").foregroundColor(Color(.systemOrange))
                    }.frame(width: 40)
                    HStack(spacing: 3) {
                        Circle().frame(width: 8, height: 8).foregroundColor(Color(.systemBlue))
                        Text("\(player.xpm)").foregroundColor(Color(.systemBlue))
                    }.frame(width: 40)
                    DamageView(maxDamage: maxDamage, playerDamage: player.heroDamage ?? 0)
                }.font(.custom(fontString, size: 10))
            }.frame(height: 50)
        }
        .onTapGesture {
            showPlayer.toggle()
        }
        .sheet(isPresented: $showPlayer) {
            PlayerDetailView(player: player)
                .environmentObject(env)
        }
    }
}

struct ItemView: View {
    @EnvironmentObject var heroData: HeroDatabase
    var id: Int
    var body: some View {

        AsyncImage(url: computeURL()) { image in
            image.resizable().renderingMode(.original)
        } placeholder: {
            Image("empty_item").resizable()
        }
        
    }
    
    private func computeURL() -> URL? {
        guard let item = HeroDatabase.shared.fetchItem(id: id) else {
            return nil
        }
        let url = URL(string: "https://api.opendota.com\(item.img)")
        //        let url = URL(string: "https://steamcdn-a.akamaihd.net\(item.img)")
        return url
    }
}

struct TeamHeaderView: View {
    var isRadiant: Bool
    var score: Int
    var win: Bool
    var body: some View {
        HStack {
            HStack {
                Text(buildTeamString())
                    .font(.custom(fontString, size: 15))
                    .bold()
                    .foregroundColor(Color(isRadiant ? .systemGreen : .systemRed))
                Text("\(win ? "🏆" : "")")
            }
            Spacer()
            Image("battle_icon")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundColor(Color(isRadiant ? .systemGreen : .systemRed))
            Text("\(score)").font(.custom(fontString, size: 15))
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color(isRadiant ? .systemGreen : .systemRed).opacity(0.2))
    }
    
    private func buildTeamString() -> LocalizedStringKey {
        if isRadiant {
            return "Radiant"
        } else {
            return "Dire"
        }
    }
}

struct TeamView: View {
    var players: [Player]
    var isRadiant: Bool
    var score: Int
    var win: Bool
    var maxDamage: Int
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 0) {
            TeamHeaderView(isRadiant: isRadiant, score: score, win: win)
            ForEach(players, id: \.heroID) { player in
                PlayerRowView(player: player, isRadiant: isRadiant, maxDamage: maxDamage)
                    .padding(.horizontal)
            }
        }
        
    }
}

struct DamageView: View {
    var maxDamage: Int
    var playerDamage: Int
    var body: some View {
        ZStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3).frame(width: 40, height: 10)
                    .foregroundColor(Color(.secondarySystemBackground))
                RoundedRectangle(cornerRadius: 3).frame(width: calculateRectangleWidth(), height: 10).foregroundColor(.red.opacity(0.4))
            }
            Text("\(playerDamage)").font(.custom(fontString, size: 10))
        }
    }
    
    private func calculateRectangleWidth() -> CGFloat {
        if maxDamage == 0 {
            return 40.0
        } else {
            return 40.0 * CGFloat(Double(playerDamage) / Double(maxDamage))
        }
    }
}
