//
//  MatchView.swift
//  App
//
//  Created by Shibo Tong on 12/8/21.
//

import SwiftUI

struct MatchView: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var data: HeroDatabase
    @Environment(\.managedObjectContext) var context
    @FetchRequest var match: FetchedResults<Match>
    @State var selectPlayer: Player?
    var matchid: String
    
    init(matchid: String) {
        _match = FetchRequest<Match>(sortDescriptors: [], predicate: NSPredicate(format: "id == %@", matchid))
        self.matchid = matchid
    }
    
    var body: some View {
        buildStack()
            .sheet(item: $selectPlayer, content: { player in
                PlayerDetailView(player: player)
                    .environmentObject(env)
            })
    }
    
    @ViewBuilder private func buildStack() -> some View {
        if let match = match.first {
            List {
                buildMatchData(match: match)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                AllTeamPlayerView(match: match, players: match.allPlayers, selectedPlayer: $selectPlayer)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                AnalysisView(vm: AnalysisViewModel(player: match.allPlayers))
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                if match.goldDiff != nil {
                    DifferenceGraphView(vm: DifferenceGraphViewModel(goldDiff: match.goldDiff, xpDiff: match.xpDiff))
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                        .frame(height: 300)
                }
            }
            .listStyle(.plain)
            .navigationTitle("ID: \(match.id ?? "")")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await loadMatch()
            }
        } else {
            LoadingView()
                .onAppear {
                    Task {
                        await loadMatch()
                    }
                }
        }
    }
    
    private func loadMatch() async {
        do {
            _ = try await OpenDotaController.shared.loadMatchData(matchid: matchid)
        } catch {
            env.error = true
        }
    }
    
    @ViewBuilder private func buildMatchData(match: Match) -> some View {
        VStack(spacing: 30) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    MatchStatCardView(icon: "calendar", title: "Start Time", label: match.startTimeString)
                        .frame(width: 140)
                    MatchStatCardView(icon: "clock", title: "Duration", label: "\(match.durationString)").colorInvert()
                        .frame(width: 140)
                    MatchStatCardView(icon: "rosette", title: "Game Mode", label: LocalizedStringKey(data.fetchGameMode(id: Int(match.mode)).modeName))
                        .frame(width: 140)
//                    MatchStatCardView(icon: "mappin.and.ellipse", title: "Region", label: vm.fetchGameRegion(id: "\(match.region)"))
//                        .colorInvert()
//                        .frame(width: 140)
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
        NavigationView {
            MatchView(matchid: "6882333505")
        }
        .environmentObject(HeroDatabase.shared)
        .environment(\.locale, .init(identifier: "zh-Hans"))
        
    }
}

struct AllTeamPlayerView: View {
    var match: Match
    var players: [Player]
    @Binding var selectedPlayer: Player?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact {
            VStack(alignment: .leading, spacing: 0) {
                Text("Players").font(.custom(fontString, size: 20)).bold().padding([.horizontal, .top])
                TeamView(players: fetchPlayers(isRadiant: true),
                         isRadiant: true,
                         score: Int(match.radiantKill),
                         win: match.radiantWin,
                         maxDamage: fetchMaxDamage(players: match.allPlayers),
                         selectedPlayer: $selectedPlayer)
                TeamView(players: fetchPlayers(isRadiant: false),
                         isRadiant: false,
                         score: Int(match.direKill),
                         win: !match.radiantWin,
                         maxDamage: fetchMaxDamage(players: match.allPlayers),
                         selectedPlayer: $selectedPlayer)
            }
            .frame(minWidth: 300)
        } else {
            VStack(alignment: .leading, spacing: 0) {
                Text("Players").font(.custom(fontString, size: 20)).bold().padding([.horizontal, .top])
                HStack {
                    TeamView(players: fetchPlayers(isRadiant: true),
                             isRadiant: true,
                             score: Int(match.radiantKill),
                             win: match.radiantWin,
                             maxDamage: fetchMaxDamage(players: match.allPlayers),
                             selectedPlayer: $selectedPlayer)
                    TeamView(players: fetchPlayers(isRadiant: false),
                             isRadiant: false,
                             score: Int(match.direKill),
                             win: !match.radiantWin,
                             maxDamage: fetchMaxDamage(players: match.allPlayers),
                             selectedPlayer: $selectedPlayer)
                }
            }
            .frame(minWidth: 300)
        }
    }
    
    func fetchMaxDamage(players: [Player]) -> Int {
        let sortedPlayers = players.sorted(by: { $0.heroDamage ?? 0 > $1.heroDamage ?? 0 })
        return Int(sortedPlayers.first?.heroDamage ?? 0)
    }
    
    private func fetchPlayers(isRadiant: Bool) -> [Player] {
        return players.filter { isRadiant ? $0.slot <= 127 : $0.slot > 127 }
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
    var maxDamage: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HeroImageView(heroID: Int(player.heroID), type: .icon)
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
                            Image("rank_\((player.rank) / 10)").resizable().frame(width: 18, height: 18)
                            Text(player.personaname!).font(.custom(fontString, size: 15)).bold().lineLimit(1)
                        }
                    } else {
                        Text("Anonymous").font(.custom(fontString, size: 15)).bold().lineLimit(1)
                    }
                    KDAView(kills: Int(player.kills), deaths: Int(player.deaths), assists: Int(player.assists), size: .caption)
                }.frame(minWidth: 0)
                Spacer()
//                if let item = player.itemNeutral {
//                    ItemView(id: Int(item))
//                        .frame(width: 24, height: 18)
//                        .clipShape(Circle())
//                        .frame(width: 8)
//                }
//                VStack(spacing: 1) {
//                    HStack(spacing: 1) {
//                        ItemView(id: Int(player.item0)).frame(width: 24, height: 18)
//                        ItemView(id: Int(player.item1)).frame(width: 24, height: 18)
//                        ItemView(id: Int(player.item2)).frame(width: 24, height: 18)
//                    }
//                    HStack(spacing: 1) {
//                        ItemView(id: Int(player.item3)).frame(width: 24, height: 18)
//                        ItemView(id: Int(player.item4)).frame(width: 24, height: 18)
//                        ItemView(id: Int(player.item5)).frame(width: 24, height: 18)
//                    }
//                }
                VStack(spacing: 0) {
                    Image("scepter_\(player.hasScepter ? "1" : "0")")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        
                    Image("shard_\(player.hasShard ? "1" : "0")")
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
                    DamageView(maxDamage: maxDamage, playerDamage: Int(player.heroDamage ?? 0))
                }.font(.custom(fontString, size: 10))
            }.frame(height: 50)
        }
    }
}

struct ItemView: View {
    @EnvironmentObject var heroData: HeroDatabase
    @State var image: UIImage?
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image).resizable()
            } else {
                Image("empty_item").resizable()
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func computeURL() -> URL? {
        guard let item = HeroDatabase.shared.fetchItem(id: id) else {
            return nil
        }
        let url = URL(string: "https://api.opendota.com\(item.img)")
        return url
    }
    
    private func loadImage() async {
        let image = try? await ImageCache.shared.fetchImage(type: .item, id: id, url: computeURL())
        self.image = image
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
    @Binding var selectedPlayer: Player?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 0) {
            TeamHeaderView(isRadiant: isRadiant, score: score, win: win)
            ForEach(players, id: \.heroID) { player in
                PlayerRowView(player: player, isRadiant: isRadiant, maxDamage: maxDamage)
                    .padding(.horizontal)
                    .onTapGesture {
                        selectedPlayer = player
                    }
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
