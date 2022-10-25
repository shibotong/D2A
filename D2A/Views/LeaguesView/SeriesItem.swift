//
//  SeriesItem.swift
//  D2A
//
//  Created by Shibo Tong on 26/10/2022.
//

import SwiftUI

struct SeriesItem: View {
    
    var series: LeagueSeries
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Date.init(timeIntervalSince1970: TimeInterval(series.scheduledTime ?? 0)).toDateString)
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
            buildTeam(teamID: series.teamOne?.id, name: series.teamOne?.name, seriesType: series.nodeType, win: series.teamOneWins)
            buildTeam(teamID: series.teamTwo?.id, name: series.teamTwo?.name, seriesType: series.nodeType, win: series.teamTwoWins)
        }
        .padding(10)
        .background{ Color.secondarySystemBackground }
        .cornerRadius(5)
        .clipped()
        .padding(.leading, 15)
    }
    
    @ViewBuilder private func buildTeam(teamID: Int?,
                                        name: String?,
                                        seriesType: LeagueNodeDefaultGroupEnum?,
                                        win: Int?) -> some View {
        HStack {
            if let teamID = teamID {
                AsyncImage(url: URL(string: "https://cdn.stratz.com/images/dota2/teams/\(teamID).png")) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 15, height: 15)
            } else {
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.gray)
                    .overlay {
                        Text("?")
                            .font(.caption2)
                    }
            }
            Text(name ?? "TBD")
            if let seriesType = seriesType {
                Spacer()
                Spacer().frame(width: 15)
                buildSeries(seriesType: seriesType, win: win)
            }
        }
    }
    
    @ViewBuilder private func buildSeries(seriesType: LeagueNodeDefaultGroupEnum,
                                          win: Int?) -> some View {
        let totalWins = seriesType.totalWins
        HStack {
            ForEach(0..<totalWins, id: \.self) { match in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(match < win ?? 0 ? .yellow : .gray.opacity(0.7))
            }
        }
        
    }
}
