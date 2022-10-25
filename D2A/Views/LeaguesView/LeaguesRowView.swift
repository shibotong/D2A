//
//  LeaguesRowView.swift
//  D2A
//
//  Created by Shibo Tong on 25/10/2022.
//

import SwiftUI

struct LeaguesRowView: View {
    
    var title: String
    var leagues: [League]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(leagues.sorted(by: { $0.liveMatches?.count ?? 0 > $1.liveMatches?.count ?? 0 }), id: \.id) { league in
                        NavigationLink(destination: LeagueDetailView(league: league)) {
                            LeagueItem(league: league)
                        }
                    }
                }
            }
        }
    }
}
