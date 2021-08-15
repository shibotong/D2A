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
        if vm.loading {
            ProgressView()
                .onAppear {
                    vm.loadMatch()
                }
        } else {
            if horizontalSizeClass == .compact {
                VStack(spacing: 0) {
                    ScoreboardView(match: vm.match).padding()
                    Divider()
                    ScrollView {
                        AllTeamPlayerView(match: vm.match).background(Color(.systemBackground))
                        DifferenceGraphView(goldDiff: vm.match.goldDiff, xpDiff: vm.match.xpDiff, mins: Double(vm.match.goldDiff.count - 1))
                            .frame(height: 300)
                            .background(Color(.systemBackground))
                            .animation(.linear(duration: 0.3))
                    }
                }
                .navigationTitle("ID: \(vm.match.id.description)")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(.secondarySystemBackground))
            } else {
                GeometryReader { proxy in
                    let width = proxy.size.width * 3 / 5
                    HStack {
                        VStack {
                            ScoreboardView(match: vm.match).padding()
                            DifferenceGraphView(goldDiff: vm.match.goldDiff, xpDiff: vm.match.xpDiff, mins: Double(vm.match.goldDiff.count - 1))
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
            }
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(vm: MatchViewModel(matchid: "123"))
    }
}

struct AllTeamPlayerView: View {
    var match: Match
    @State var selectedPlayer: Player?
    var body: some View {
        VStack(alignment: .leading) {
            Text("Overview").font(.custom(fontString, size: 20)).bold().padding([.horizontal, .top])
            TeamView(players: match.fetchPlayers(isRadiant: true), isRadiant: true, selectedPlayer: $selectedPlayer)
            TeamView(players: match.fetchPlayers(isRadiant: false), isRadiant: false, selectedPlayer: $selectedPlayer)
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
                HeroIconImageView(heroID: player.heroID).equatable().frame(width: 35, height: 35)
                VStack(alignment: .leading) {
                    Text("\(player.personaname ?? "Anolymous")").font(.custom(fontString, size: 15)).bold()
                    Text("LVL \(player.level) \(HeroDatabase.shared.fetchHeroWithID(id: player.heroID)?.localizedName.uppercased() ?? "")").font(.custom(fontString, size: 10)).foregroundColor(Color(.secondaryLabel))
                }
                Spacer()
                VStack (alignment: .trailing, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("\(player.kills)")
                        Text("/\(player.deaths)/\(player.assists)").foregroundColor(Color(.systemGray))
                    }
                    HStack(spacing: 3) {
                        Circle().frame(width: 8, height: 8).foregroundColor(Color(.systemYellow))
                        Text("\(player.netWorth)").foregroundColor(Color(.systemOrange))
                    }
                }.font(.custom(fontString, size: 12))
            }.frame(height: 50)
            if player.heroID == selectedPlayer?.heroID {
                PlayerDetailView(player: player).transition(.opacity)
            }
        }
        .animation(.linear(duration: 0.2))
        
    }
}

struct ScoreboardView: View {
    var match: Match
    var body: some View {
        VStack {
            Text("\(match.radiantWin ? "RADIANT": "DIRE") VICTORY").font(.custom(fontString, size: 20)).bold()
            HStack {
                Text("\(match.radiantKill)")
                    .foregroundColor(Color(.systemGreen))
                Text(" - ")
                Text("\(match.direKill)")
                    .foregroundColor(Color(.systemRed))
            }.font(.custom(fontString, size: 40))
            Text("Match duration - \(match.duration.convertToDuration())").font(.custom(fontString, size: 15)).foregroundColor(Color(.systemGray))
        }
    }
}

struct TeamHeaderView: View {
    var isRadiant: Bool
    var body: some View {
        VStack(spacing: 0) {
            Rectangle().frame(height: 1).foregroundColor(Color(isRadiant ? .systemGreen : .systemRed))
            HStack {
                Text("\(isRadiant ? "Radiant" : "Dire")")
                    .font(.custom(fontString, size: 10))
                    .bold()
                    .padding(5)
                    .frame(width: 50)
                    .foregroundColor(Color(.systemBackground))
                    .background(Color(isRadiant ? .systemGreen : .systemRed))
                Spacer()
            }
        }
        
    }
}

struct TeamView: View {
    var players: [Player]
    var isRadiant: Bool
    @Binding var selectedPlayer: Player?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 0) {
                TeamHeaderView(isRadiant: isRadiant)
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
