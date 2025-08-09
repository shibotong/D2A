//
//  MatchView.swift
//  App
//
//  Created by Shibo Tong on 12/8/21.
//

import SwiftUI

struct MatchView: View {
    @EnvironmentObject var env: EnvironmentController
    @EnvironmentObject var data: ConstantsController
    @Environment(\.managedObjectContext) var context
    @FetchRequest private var match: FetchedResults<Match>
    private var matchid: String

    init(matchid: String) {
        _match = FetchRequest<Match>(
            sortDescriptors: [], predicate: NSPredicate(format: "id = %@", matchid))
        self.matchid = matchid
    }

    var body: some View {
        buildStack()
    }

    @ViewBuilder private func buildStack() -> some View {
        if let match = match.first {
            List {
                buildMatchData(match: match)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                AllTeamPlayerView(match: match, players: match.allPlayers)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                AnalysisView(players: match.players?.map { PlayerRowViewModel(player: $0) } ?? [])
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                if let goldDiff = match.goldDiff, let xpDiff = match.xpDiff {
                    DifferenceGraphView(
                        vm: DifferenceGraphViewModel(goldDiff: goldDiff, xpDiff: xpDiff)
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                    .frame(height: 300)
                }
            }
            .listStyle(.plain)
            .navigationTitle("ID: \(match.id ?? "")")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                Button {
                    Task {
                        await loadMatch()
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }

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
            _ = try await OpenDotaProvider.shared.loadMatchData(matchid: matchid)
        } catch {
            env.errorMessage = error.localizedDescription
            env.error = true
        }
    }

    @ViewBuilder private func buildMatchData(match: Match) -> some View {
        VStack(spacing: 30) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    MatchStatCardView(
                        icon: "calendar", title: "Start Time", label: match.startTimeString
                    )
                    .frame(width: 140)
                    MatchStatCardView(
                        icon: "clock", title: "Duration", label: "\(match.durationString)"
                    )
                    .colorInvert()
                    .frame(width: 140)
                    MatchStatCardView(
                        icon: "rosette", title: "Game Mode",
                        label: LocalizedStringKey(data.fetchGameMode(id: Int(match.mode))?.modeName ?? "Unknown")
                    )
                    .frame(width: 140)
                    MatchStatCardView(
                        icon: "mappin.and.ellipse", title: "Region",
                        label: LocalizedStringKey(data.fetchRegion(id: match.region.description))
                    )
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
                    Text(title).font(.system(size: 10)).foregroundColor(Color(.secondaryLabel))
                    Text(label).font(.system(size: 15)).bold().lineLimit(2)
                }
                Spacer()
            }.padding(18)
        }
    }
}

// struct MatchView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            MatchView(matchid: "123")
//        }
//        .environmentObject(ConstantsController.shared)
//        .environmentObject(EnvironmentController.shared)
//        .environment(\.managedObjectContext, PersistanceController.preview.container.viewContext)
//        .environment(\.locale, .init(identifier: "zh-Hans"))
//
//    }
// }

struct AllTeamPlayerView: View {
    var match: Match
    var players: [Player]
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Players").font(.system(size: 20)).bold().padding([.horizontal, .top])
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    TeamView(
                        players: fetchPlayers(isRadiant: true),
                        isRadiant: true,
                        score: Int(match.radiantKill),
                        win: match.radiantWin,
                        maxDamage: fetchMaxDamage(players: match.allPlayers))
                    TeamView(
                        players: fetchPlayers(isRadiant: false),
                        isRadiant: false,
                        score: Int(match.direKill),
                        win: !match.radiantWin,
                        maxDamage: fetchMaxDamage(players: match.allPlayers))
                }
            }
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

struct TeamHeaderView: View {
    var isRadiant: Bool
    var score: Int
    var win: Bool

    private var teamString: LocalizedStringKey {
        return isRadiant ? "Radiant" : "Dire"
    }

    var body: some View {
        HStack {
            Image("battle_icon")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundColor(Color(isRadiant ? .systemGreen : .systemRed))
            Text("\(score)").font(.system(size: 15))
            HStack {
                Text(teamString)
                    .font(.system(size: 15))
                    .bold()
                    .foregroundColor(Color(isRadiant ? .systemGreen : .systemRed))
                Text("\(win ? "🏆" : "")")
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color(isRadiant ? .systemGreen : .systemRed).opacity(0.2))
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
                PlayerRowView(maxDamage: maxDamage, viewModel: PlayerRowViewModel(player: player))
                    .padding(.horizontal)
            }
        }

    }
}
