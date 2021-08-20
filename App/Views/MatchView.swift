//
//  MatchView.swift
//  App
//
//  Created by Shibo Tong on 12/8/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MatchView: View {
    @EnvironmentObject var env: DotaEnvironment
    @ObservedObject var vm: MatchViewModel
    @EnvironmentObject var data: HeroDatabase
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        if vm.id == nil {
            Text("select a match")
        } else {
            if vm.match == nil {
                Text("something went error loading match")
                    .onAppear {
                        vm.loadNewMatch()
                    }
            } else {
                if horizontalSizeClass == .regular {
                    VStack {
                        if vm.loading {
                            LoadingView()
                                .frame(height: 50)
                                .transition(.flipFromTop)
                        }
                    HStack(spacing: 0) {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 160, maximum: .infinity), spacing: 20), count: 2), spacing: 20, content: {
                                MatchStatCardView(icon: "calendar", title: "Start Time", label: "\(vm.match!.startTime.convertToTime())")
                                MatchStatCardView(icon: "clock", title: "Duration", label: "\(vm.match!.duration.convertToDuration())")
                                    .colorInvert()
                                MatchStatCardView(icon: "rosette", title: "Game Mode", label: "\(data.fetchGameMode(id: vm.match!.mode).fetchModeName())")
                                    .colorInvert()
                                MatchStatCardView(icon: "mappin.and.ellipse", title: "Region", label: "\(data.fetchRegion(id: "\(vm.match!.region)"))")
                            }).padding()
                            DifferenceGraphView(vm: DifferenceGraphViewModel(goldDiff: vm.match!.goldDiff, xpDiff: vm.match!.xpDiff))
                                .frame(height: 300)
                                .animation(.linear(duration: 0.3))
                                .padding(.horizontal)
                            Divider().padding(.horizontal, 80)
                            AnalysisView(vm: AnalysisViewModel(player: vm.match!.players))
                                .background(Color(.systemBackground))
                                .animation(.linear(duration: 0.3))
                                .padding(.horizontal)
                            
                        }
                        Divider().padding(.vertical, 80)
                        ScrollView(showsIndicators: false) {
                            AllTeamPlayerView(match: vm.match!)
                                .background(Color(.systemBackground))
                                .padding(.horizontal)
                        }.frame(width: 350)
                    }
                    }
                    .navigationTitle("\(vm.match!.radiantWin ? "Radiant" : "Dire") Win")
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    ScrollView {
                        if vm.loading {
                            LoadingView()
                                .frame(height: 50)
                                .transition(.flipFromTop)
                        }
                        VStack(spacing: 10) {
                            VStack(spacing: 30) {
                                HStack(spacing: 15) {
                                    MatchStatCardView(icon: "calendar", title: "Start Time", label: "\(vm.match!.startTime.convertToTime())")
                                    MatchStatCardView(icon: "clock", title: "Duration", label: "\(vm.match!.duration.convertToDuration())").colorInvert()
                                }
                            }.padding([.top, .horizontal])
                            AllTeamPlayerView(match: vm.match!)
                            AnalysisView(vm: AnalysisViewModel(player: vm.match!.players))
                            DifferenceGraphView(vm: DifferenceGraphViewModel(goldDiff: vm.match!.goldDiff, xpDiff: vm.match!.xpDiff))
                                .frame(height: 300)
                        }
                    }
                    .navigationTitle("\(vm.match!.radiantWin ? "Radiant" : "Dire") Win")
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarItems(trailing: Button(action: {
                        withAnimation(.linear) {
                            vm.refresh()
                        }
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    }))
                }
            }
        }
    }
    
}

struct MatchStatCardView: View {
    var icon: String
    var title: String
    var label: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15.0).foregroundColor(Color(.secondarySystemBackground))
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Image(systemName: icon).font(.largeTitle)
                    Text(title).font(.custom(fontString, size: 13)).foregroundColor(Color(.secondaryLabel))
                    Text(label).font(.custom(fontString, size: 18)).bold().lineLimit(0)
                }
                Spacer()
            }.padding(18)
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmptyView()
            MatchView(vm: MatchViewModel())
        }
        .environmentObject(HeroDatabase.shared)
        
    }
}

struct AllTeamPlayerView: View {
    var match: Match
    @State var selectedPlayer: Player?
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Players").font(.custom(fontString, size: 20)).bold().padding([.horizontal, .top])
            TeamView(players: match.fetchPlayers(isRadiant: true), isRadiant: true, score: match.fetchKill(isRadiant: true))
            TeamView(players: match.fetchPlayers(isRadiant: false), isRadiant: false, score: match.fetchKill(isRadiant: false))
        }
        .frame(minWidth: 300)
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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HeroIconImageView(heroID: player.heroID)
                    //                Image("hero_icon")
                    .frame(width: 35, height: 35)
                VStack(alignment: .leading) {
                    Text("\(player.personaname ?? "Anolymous")").font(.custom(fontString, size: 15)).bold().lineLimit(1)
                    Text("LVL \(player.level) \(HeroDatabase.shared.fetchHeroWithID(id: player.heroID)?.localizedName.uppercased() ?? "")").font(.custom(fontString, size: 10)).foregroundColor(Color(.secondaryLabel))
                        .lineLimit(1)
                }.frame(minWidth: 0)
                Spacer()
                
                VStack(spacing: 0) {
                    HStack(spacing: 3) {
                        Circle().frame(width: 8, height: 8).foregroundColor(Color(.systemYellow))
                        Text("\(player.gpm)").foregroundColor(Color(.systemOrange))
                    }.frame(width: 35)
                    HStack(spacing: 3) {
                        Circle().frame(width: 8, height: 8).foregroundColor(Color(.systemBlue))
                        Text("\(player.xpm)").foregroundColor(Color(.systemBlue))
                    }.frame(width: 35)
                    
                }.font(.custom(fontString, size: 12))
            }.frame(height: 50)
            HStack {
                ItemView(id: player.item0)
                ItemView(id: player.item1)
                ItemView(id: player.item2)
                ItemView(id: player.item3)
                ItemView(id: player.item4)
                ItemView(id: player.item5)
                if player.itemNeutral != nil {
                    ItemView(id: player.itemNeutral!).clipShape(Circle())
                }
                Spacer()
                HStack(spacing: 0) {
                    Text("\(player.kills)").bold()
                    Text("/\(player.deaths)/\(player.assists)").foregroundColor(Color(.systemGray)).lineLimit(1)
                    
                }.frame(minWidth:45).font(.custom(fontString, size: 15))
            }
        }.padding(.vertical)
        
    }
}

struct ItemView: View {
    @EnvironmentObject var heroData: HeroDatabase
    var id: Int
    var body: some View {
        if computeURL() == nil {
            Image("empty_item").resizable().frame(width: 24, height: 18)
        } else {
            WebImage(url: computeURL())
                .resizable()
                .renderingMode(.original)
                .indicator(.init(content: { _, _ in
                    Image("empty_item")
                        .resizable()
                        .frame(width: 24, height: 18)
                }))
                .transition(.fade)
                .frame(width: 24, height: 18)
        }
    }
    
    private func computeURL() -> URL? {
        guard let item = heroData.fetchItem(id: id) else {
            return nil
        }
        let url = URL(string: "https://api.opendota.com\(item.img)")
        return url
    }
}

struct ScoreboardView: View {
    var match: RecentMatch
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            HStack {
                Spacer()
                Text("\(match.fetchMode().fetchModeName()) | \(Int(match.startTime).convertToTime()) | \(Int(match.duration).convertToDuration())").font(.custom(fontString, size: 13))
            }.foregroundColor(Color(.secondaryLabel))
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color(match.radiantWin ? .systemGreen : .systemRed).opacity(0.4).ignoresSafeArea())
    }
}

struct TeamHeaderView: View {
    var isRadiant: Bool
    var score: Int
    var body: some View {
        HStack {
            Text("\(isRadiant ? "Radiant" : "Dire")")
                .font(.custom(fontString, size: 15))
                .bold()
                .foregroundColor(Color(isRadiant ? .systemGreen : .systemRed))
            
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
        //            .background(isRadiant ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
        
        
    }
}

struct TeamView: View {
    var players: [Player]
    var isRadiant: Bool
    var score: Int
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 0) {
            TeamHeaderView(isRadiant: isRadiant, score: score)
            ForEach(players, id: \.heroID) { player in
                PlayerRowView(player: player, isRadiant: isRadiant)
                    .padding(.horizontal)
                
                
            }
        }
    }
}
