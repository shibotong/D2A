//
//  ScoreView.swift
//  D2A
//
//  Created by Shibo Tong on 22/10/2022.
//

import SwiftUI

struct ScoreView: View {
    
    var radiantTeam: MatchLiveSubscription.Data.MatchLive.RadiantTeam?
    var direTeam: MatchLiveSubscription.Data.MatchLive.DireTeam?
    
    var radiantScore: Int = 0
    var direScore: Int = 0
    
    var time: Int = 0
    
    var body: some View {
        HStack {
            teamIcon(isRadiant: true)
            teamScore(score: radiantScore)
            Spacer()
            buildTime(time)
            Spacer()
            teamScore(score: direScore)
            teamIcon(isRadiant: false)
        }
    }
    
    @ViewBuilder private func teamIcon(isRadiant: Bool) -> some View {
        if isRadiant {
            if let team = radiantTeam, let url = team.url {
                AsyncImage(url: URL(string: url)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 30, height: 30)
            } else {
                Image("radiant_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        } else {
            if let team = direTeam, let url = team.url {
                AsyncImage(url: URL(string: url)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 30, height: 30)
            } else {
                Image("dire_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
        
    }
    
    @ViewBuilder private func teamScore(score: Int) -> some View {
        Text("\(score)")
            .bold()
            .font(.title3)
    }
    
    @ViewBuilder private func buildTime(_ seconds: Int) -> some View {
        let time = seconds.convertToDuration()
        let day: Bool = (seconds / 300) % 2 == 0
        VStack {
            Image(systemName: day ? "sun.max" : "moon.fill")
                .foregroundColor(day ? .orange : .blue)
            Text("\(time)")
                .font(.footnote)
                .bold()
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
