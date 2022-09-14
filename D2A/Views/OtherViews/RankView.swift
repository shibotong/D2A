//
//  RankView.swift
//  App
//
//  Created by Shibo Tong on 12/6/2022.
//

import SwiftUI

struct RankView: View {
    
    var rank: Int?
    var leaderboard: Int?
    
    var body: some View {
        ZStack {
            buildBadge(rank: rank ?? 0, leaderboard: leaderboard)
            if let rank = rank {
                buildStar(rank: rank, leaderboard: leaderboard)
            }
        }
        
    }
    
    @ViewBuilder
    private func buildBadge(rank: Int, leaderboard: Int?) -> some View {
        if rank == 80 {
            if let leaderboard = leaderboard {
                if leaderboard <= 10 {
                    Image("rank_icon_8c").resizable()
                } else if leaderboard <= 100 {
                    Image("rank_icon_8b").resizable()
                } else {
                    Image("rank_icon_8").resizable()
                }
            } else {
                Image("rank_icon_8").resizable()
            }
        } else {
            Image("rank_icon_\(rank / 10)").resizable()
        }
    }
    
    @ViewBuilder
    private func buildStar(rank: Int, leaderboard: Int?) -> some View {
        if rank < 80 {
            Image("rank_star_\(rank % 10)").resizable()
        } else {
            if let leaderboard = leaderboard {
                GeometryReader { proxy in
                    Text("\(leaderboard.description)")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: proxy.size.width, height: proxy.size.height / 6.0)
                        .scaleEffect(proxy.size.height / 200)
                        .offset(y: proxy.size.height * 0.75)
                }
            }
        }
    }
}

struct RankView_Previews: PreviewProvider {
    static var previews: some View {
        RankView(rank: 75, leaderboard: 100)
            .previewLayout(.fixed(width: 200, height: 200))
        RankView(rank: 80, leaderboard: 1)
            .previewLayout(.fixed(width: 100, height: 100))
        RankView(rank: 80, leaderboard: 1)
            .previewLayout(.fixed(width: 50, height: 50))
    }
}
