//
//  MatchView.swift
//  App
//
//  Created by Shibo Tong on 12/8/21.
//

import SwiftUI

struct MatchView: View {
    @ObservedObject var vm: MatchViewModel
    var body: some View {
        if vm.loading {
            ProgressView()
                .onAppear {
                    vm.loadMatch()
                }
        } else {
            VStack(spacing: 0) {
                ScoreboardView(match: vm.match).padding()
                Divider()
                ScrollView {
                    GraphView(match: vm.match)
                }
            }
            .navigationTitle("ID: \(vm.match.id.description)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(vm: MatchViewModel(matchid: "123"))
    }
}

struct GraphView: View {
    var match: Match
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var selectedPlayer: Player?
    var body: some View {
        if horizontalSizeClass == .compact {
            TeamView(players: match.fetchPlayers(isRadiant: true), isRadiant: true, selectedPlayer: $selectedPlayer)
            if selectedPlayer == nil {
                DifferenceGraphView(goldDiff: match.goldDiff, xpDiff: match.xpDiff)
            } else {
                PlayerDetailView(player: selectedPlayer!)
            }
            TeamView(players: match.fetchPlayers(isRadiant: false), isRadiant: false, selectedPlayer: $selectedPlayer)
        } else {
            HStack {
                TeamView(players: match.fetchPlayers(isRadiant: true), isRadiant: true, selectedPlayer: $selectedPlayer)
                if selectedPlayer == nil {
                    DifferenceGraphView(goldDiff: match.goldDiff, xpDiff: match.xpDiff)
                } else {
                    PlayerDetailView(player: selectedPlayer!)
                }
                TeamView(players: match.fetchPlayers(isRadiant: false), isRadiant: false, selectedPlayer: $selectedPlayer)
            }
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
        if horizontalSizeClass == .compact {
            VStack(spacing: 0) {
                HeroIconImageView(heroID: player.heroID).equatable()
                    .frame(width: 32, height: 32)
                HStack(spacing: 1) {
                    Circle().frame(width: 10, height: 10).foregroundColor(Color(.systemYellow))
                    Text("\(player.netWorth)")
                }
                Text("\(player.kills)/\(player.deaths)/\(player.assists)")
            }
            .padding(5)
            .font(.custom(fontString, size: 13))
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 20).stroke(Color(isRadiant ? .systemGreen : .systemRed), lineWidth: player.heroID == selectedPlayer?.heroID ? 3 : 1))
            .onTapGesture {
                onClickFunction()
            }
        } else {
            HStack(spacing: 5) {
                Image("hero_icon")
                VStack(spacing: 1) {
                    HStack(spacing: 1) {
                        Circle().frame(width: 10, height: 10).foregroundColor(Color(.systemYellow))
                        Text("\(player.netWorth)")
                    }
                    Text("\(player.kills)/\(player.deaths)/\(player.assists)")
                }
            }
            .padding(5)
            .font(.custom(fontString, size: 13))
            .frame(maxHeight: .infinity)
            .background(RoundedRectangle(cornerRadius: 15).stroke(Color(isRadiant ? .systemGreen : .systemRed), lineWidth: player.heroID == selectedPlayer?.heroID ? 3 : 1))
            .onTapGesture {
                onClickFunction()
            }
        }
    }
    
    private func onClickFunction() {
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
                    .font(.custom(fontString, size: 18))
                    .bold()
                    .padding(5)
                    .frame(width: 80)
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
        if horizontalSizeClass == .compact {
            HStack {
                ForEach(players, id: \.heroID) { player in
                    PlayerRowView(player: player, isRadiant: isRadiant, selectedPlayer: $selectedPlayer)
                }
            }.padding(5)
        } else {
            VStack {
                ForEach(players, id: \.heroID) { player in
                    PlayerRowView(player: player, isRadiant: isRadiant, selectedPlayer: $selectedPlayer)
                }
            }.padding(5)
        }
    }
}
