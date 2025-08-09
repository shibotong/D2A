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
                        .frame(width: 100, height: 100)
                        .frame(width: proxy.size.width, height: proxy.size.height / 6.0)
                        .scaleEffect(proxy.size.height / 200)
                        .offset(y: proxy.size.height * 0.75)
                }
            }
        }
    }
}

struct RankView_Previews: PreviewProvider {
    static let frameLength: CGFloat = 40
    static var previews: some View {
        Group {
            VStack {
                ForEach(1..<8) { badge in
                    HStack {
                        ForEach(1..<6) { star in
                            let rank = badge * 10 + star
                            RankView(rank: rank, leaderboard: nil)
                                .frame(width: frameLength, height: frameLength)
                        }
                    }
                }
                RankView(rank: 80, leaderboard: 9999)
                    .frame(width: 50, height: 50)
            }
            .previewLayout(.fixed(width: 400, height: 500))
            RankView(rank: 80, leaderboard: 9999)
                .previewLayout(.fixed(width: frameLength, height: frameLength))
        }
    }
}
