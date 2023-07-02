//
//  LiveMatchListRowView.swift
//  D2A
//
//  Created by Shibo Tong on 28/6/2023.
//

import SwiftUI

struct LiveMatchListRowView: View {
    
    var radiantScore: Int
    var direScore: Int
    var radiantHeroes: [LiveMatchRowPlayer]
    var direHeroes: [LiveMatchRowPlayer]
    
    var radiantTeam: String?
    var direTeam: String?
    
    let averageRank: Int
    let leagueID: Int?
    let leagueName: String?
    
    private let teamIconLength: CGFloat = 50
    
    var body: some View {
        VStack {
            if let leagueID, let leagueName {
                HStack {
                    LiveMatchLeagueIconView(viewModel: .init(leagueID: leagueID))
                        .frame(height: 20)
                    Text(leagueName)
                        .lineLimit(1)
                        .font(.caption)
                    Spacer()
                }
            } else {
                HStack {
                    Spacer()
                    Text("\(averageRank) average MMR")
                        .font(.caption)
                        .foregroundColor(.secondaryLabel)
                }
            }
            HStack {
                Spacer()
                LiveMatchTeamIconView(viewModel: LiveMatchTeamIconViewModel(teamID: radiantTeam, isRadiant: true))
                    .cornerRadius(10)
                    .frame(width: teamIconLength, height: teamIconLength)
                Spacer()
                Text("\(radiantScore) - \(direScore)")
                    .font(.title)
                    .bold()
                Spacer()
                LiveMatchTeamIconView(viewModel: LiveMatchTeamIconViewModel(teamID: direTeam, isRadiant: false))
                    .cornerRadius(10)
                    .frame(width: teamIconLength, height: teamIconLength)
                Spacer()
            }
            HStack {
                buildHeroes(heroes: radiantHeroes, isRadiant: true)
                Spacer()
                buildHeroes(heroes: direHeroes, isRadiant: false)
            }
        }
        .foregroundColor(.label)
        .padding()
        .background(Color.secondarySystemBackground)
        .cornerRadius(15)
    }
    
    @ViewBuilder
    private func buildHeroes(heroes: [LiveMatchRowPlayer], isRadiant: Bool) -> some View {
        VStack(alignment: isRadiant ? .leading : .trailing) {
            ForEach(heroes) { hero in
                HStack {
                    if isRadiant {
                        HeroImageView(heroID: hero.heroID, type: .icon)
                            .frame(height: 30)
                        Text(hero.playerName ?? "Anonymous")
                            .lineLimit(1)
                    } else {
                        Text(hero.playerName ?? "Anonymous")
                            .lineLimit(1)
                        HeroImageView(heroID: hero.heroID, type: .icon)
                            .frame(height: 30)
                        
                    }
                }
            }
        }
    }
}

struct LiveMatchRowPlayer: Identifiable {
    
    var id: Int {
        return slot
    }
    
    let heroID: Int
    let playerName: String?
    let slot: Int
    
    static let stubRadiant: [LiveMatchRowPlayer] = [.init(heroID: 1, playerName: "solo", slot: 1),
                                                    .init(heroID: 2, playerName: "maybe", slot: 2),
                                                    .init(heroID: 3, playerName: "ame", slot: 3),
                                                    .init(heroID: 4, playerName: "xinq", slot: 4),
                                                    .init(heroID: 5, playerName: "y", slot: 5)]
    
    static let stubDire: [LiveMatchRowPlayer] = [.init(heroID: 6, playerName: "solo", slot: 6),
                                                 .init(heroID: 7, playerName: "maybe", slot: 7),
                                                 .init(heroID: 8, playerName: "ame", slot: 8),
                                                 .init(heroID: 9, playerName: "xinq", slot: 9),
                                                 .init(heroID: 10, playerName: "y", slot: 10)]
}

struct LiveMatchListRowView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchListRowView(radiantScore: 1,
                             direScore: 1,
                             radiantHeroes: LiveMatchRowPlayer.stubRadiant,
                             direHeroes: LiveMatchRowPlayer.stubDire,
                             radiantTeam: nil,
                             direTeam: nil,
        averageRank: 1000, leagueID: nil, leagueName: nil)
        LiveMatchListRowView(radiantScore: 1,
                             direScore: 1,
                             radiantHeroes: LiveMatchRowPlayer.stubRadiant,
                             direHeroes: LiveMatchRowPlayer.stubDire,
                             radiantTeam: nil,
                             direTeam: nil,
        averageRank: 1000, leagueID: 15352, leagueName: "Summer")
    }
}