//
//  MatchView.swift
//  App
//
//  Created by Shibo Tong on 12/8/21.
//

import SwiftUI

struct MatchView: View {
    @ObservedObject var vm: MatchViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        if horizontalSizeClass == .regular {
            GeometryReader { proxy in
                let width = proxy.size.width * 3 / 5
                HStack {
                    VStack {
                        DifferenceGraphView(goldDiff: vm.match.goldDiff!, xpDiff: vm.match.xpDiff!)
                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color(.systemBackground)))
                            .padding()
                            .animation(.linear(duration: 0.3))
                        
                    }
                    .frame(width: width)
                    .padding()
                    ScrollView {
                        AllTeamPlayerView(match: vm.match).background(Color(.systemBackground))
                    }
                }
                .background(Color(.secondarySystemBackground))
                .navigationTitle("ID: \(vm.match.id.description)")
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            VStack(spacing: 0) {
                ScoreboardView(match: vm.recentMatch)
                if vm.loading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            vm.loadMatch()
                        }
                } else {
                    ScrollView {
                        AllTeamPlayerView(match: vm.match)
                            .background(Color(.systemBackground))

                        AnalysisView(players: vm.match.players)
                            .background(Color(.systemBackground))
                            .animation(.linear(duration: 0.3))
                                                DifferenceGraphView(goldDiff: vm.match.goldDiff, xpDiff: vm.match.xpDiff)
                                                    .frame(height: 300)
                                                    .background(Color(.systemBackground))
                                                    .animation(.linear(duration: 0.3))
                        
                    }
                    .background(Color(.secondarySystemBackground))
                }
            }
            .navigationBarHidden(true)
        }
        
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {

            MatchView(vm: MatchViewModel(previewMatch: Match.sample))
                .previewLayout(.fixed(width: 350, height: 2000))
        
    }
}

struct AllTeamPlayerView: View {
    var match: Match
    @State var selectedPlayer: Player?
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Overview").font(.custom(fontString, size: 20)).bold().padding([.horizontal, .top])
            TeamView(players: match.fetchPlayers(isRadiant: true), isRadiant: true, score: match.radiantKill, selectedPlayer: $selectedPlayer)
            TeamView(players: match.fetchPlayers(isRadiant: false), isRadiant: false, score: match.direKill, selectedPlayer: $selectedPlayer)
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
    @Binding var selectedPlayer: Player?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 0){
            HStack {
//                HeroIconImageView(heroID: player.heroID).equatable()
                Image("hero_icon")
                    .frame(width: 35, height: 35)
                VStack(alignment: .leading) {
                    Text("\(player.personaname ?? "Anolymous")").font(.custom(fontString, size: 15)).bold().lineLimit(1)
                    Text("LVL \(player.level) \(HeroDatabase.shared.fetchHeroWithID(id: player.heroID)?.localizedName.uppercased() ?? "")").font(.custom(fontString, size: 10)).foregroundColor(Color(.secondaryLabel))
                }
                Spacer()
                VStack (alignment: .trailing, spacing: 0) {
                    HStack(spacing: 1) {
                        ItemView(vm: ItemViewModel(id: player.item0))
                        ItemView(vm: ItemViewModel(id: player.item1))
                        ItemView(vm: ItemViewModel(id: player.item2))
                        ItemView(vm: ItemViewModel(id: player.item3))
                        ItemView(vm: ItemViewModel(id: player.item4))
                        ItemView(vm: ItemViewModel(id: player.item5))
                        ItemView(vm: ItemViewModel(id: player.itemNeutral)).clipShape(Circle())
                    }
                    HStack(spacing: 6) {
                        HStack(spacing: 0) {
                            
                            Text("\(player.kills)")
                            Text("/\(player.deaths)/\(player.assists)").foregroundColor(Color(.systemGray)).lineLimit(1)
                            
                        }
                        HStack(spacing: 3) {
                            Circle().frame(width: 8, height: 8).foregroundColor(Color(.systemYellow))
                            Text("\(player.gpm)").foregroundColor(Color(.systemOrange))
                        }
                        HStack(spacing: 3) {
                            Circle().frame(width: 8, height: 8).foregroundColor(Color(.systemBlue))
                            Text("\(player.xpm)").foregroundColor(Color(.systemBlue))
                        }
                    }
                }.font(.custom(fontString, size: 12))
            }.frame(height: 50)
        }
        .animation(.linear(duration: 0.2))
        
    }
}

struct ItemView: View {
    @ObservedObject var vm: ItemViewModel
    var body: some View {
        Image(uiImage: vm.itemImage).resizable().frame(width: 20, height: 15)
    }
}

struct ScoreboardView: View {
    var match: RecentMatch
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(.white))
                }
                Spacer()
            }
            HStack {
                Text("\(match.radiantWin ? "Radiant" : "Dire") Victory").font(.custom(fontString, size: 25)).bold()
                Spacer()
                Text("All Pick | 18:00 | 24:56").font(.custom(fontString, size: 12))
            }.foregroundColor(Color(.white))
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color(match.radiantWin ? .systemGreen : .systemRed).opacity(0.8).ignoresSafeArea())
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
            .background(isRadiant ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
        
        
    }
}

struct TeamView: View {
    var players: [Player]
    var isRadiant: Bool
    var score: Int
    @Binding var selectedPlayer: Player?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 0) {
            TeamHeaderView(isRadiant: isRadiant, score: score)
                ForEach(players, id: \.heroID) { player in
                    PlayerRowView(player: player, isRadiant: isRadiant, selectedPlayer: $selectedPlayer)
                        .padding(.horizontal)
                        .background(Rectangle().stroke(Color(.systemGray6)))
                        .onTapGesture {
                            onClickFunction(player: player)
                        }
                    
                }
            }
    }
    
    private func onClickFunction(player: Player) {
        guard let selected = selectedPlayer else {
            selectedPlayer = player
            return
        }
        if selected.heroID == player.heroID {
            selectedPlayer = nil
        } else {
            selectedPlayer = player
        }
    }
}
