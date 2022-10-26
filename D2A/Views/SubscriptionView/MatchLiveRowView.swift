//
//  MatchLiveRowView.swift
//  D2A
//
//  Created by Shibo Tong on 26/10/2022.
//

import SwiftUI

struct MatchLiveRowView: View {
    
    @ObservedObject var viewModel: MatchLiveViewModel
    var parsing: Bool
    
    init(matchID: Int, isParsing: Bool) {
        parsing = isParsing
        viewModel = .init(matchID: matchID)
        viewModel.startFetching()
    }
    
    init() {
        viewModel = MatchLiveViewModel()
        parsing = true
    }
    
    var emptyTeam: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3).frame(width: 50, height: 15).foregroundColor(.gray)
            buildTeam(team: nil, score: nil)
            buildTeam(team: nil, score: nil)
        }
    }
    
    var body: some View {
        NavigationLink(destination: MatchLiveView(viewModel: viewModel)) {
            main
        }
    }
    
    var main: some View {
        ZStack {
            Color.secondarySystemBackground
            Group {
                if let match = viewModel.matchLive {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(match.duration.convertToDuration())
                                .foregroundColor(.secondaryLabel)
                                .font(.caption)
                            Spacer()
                            if parsing {
                                LiveIndicator()
                            }
                        }
                        if let radiantTeam = match.radiantTeam, let direTeam = match.direTeam {
                            buildTeam(team: radiantTeam, score: match.radiantKill)
                            buildTeam(team: direTeam, score: match.direKill)
                        }
                    }
                } else {
                    emptyTeam
                }
            }.padding()
        }
        .foregroundColor(.label)
        .cornerRadius(10)
        .clipped()
    }

    @ViewBuilder private func buildTeam(team: Team?, score: Int?) -> some View {
        HStack {
            if let team = team {
                team.image
                    .frame(width: 15, height: 15)
                Text(team.name)
            } else {
                Circle().foregroundColor(.gray).frame(width: 15, height: 15)
                RoundedRectangle(cornerRadius: 3).foregroundColor(.gray).frame(width: 100, height: 15)
            }
            Spacer()
            Text("\(score?.description ?? "   ")").bold()
        }
    }
}

struct MatchLiveRowView_Previews: PreviewProvider {
    static var previews: some View {
        MatchLiveRowView()
    }
}
