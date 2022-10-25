//
//  LeaguesHomeView.swift
//  D2A
//
//  Created by Shibo Tong on 25/10/2022.
//

import SwiftUI

struct LeaguesHomeView: View {
    
    @StateObject var viewModel = LeaguesHomeViewModel()
    @Environment (\.horizontalSizeClass) private var horizontalClass
    
    private let leagueTiers: [LeagueTier] = [.international, .major, .dpcLeague, .dpcQualifier, .dpcLeagueFinals, .dpcLeagueQualifier, .professional, .amateur]
    
    var body: some View {
        List {
            if !viewModel.upcomingMatches.isEmpty {
                SeriesRowView(series: viewModel.upcomingMatches)
                    .frame(height: 160)
                    .listRowInsets(EdgeInsets())
            }
            ForEach(leagueTiers, id: \.self) { leagueTier in
                let leagues = viewModel.leagues.filter( { $0.tier == leagueTier} )
                if !leagues.isEmpty {
                    LeaguesRowView(title: leagueTier.rawValue, leagues: leagues)
                        .frame(height: 200)
                        .listRowInsets(EdgeInsets())
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Leagues")
    }
}

struct LeaguesHomeView_Previews: PreviewProvider {
    static var previews: some View {
        LeaguesHomeView()
    }
}
