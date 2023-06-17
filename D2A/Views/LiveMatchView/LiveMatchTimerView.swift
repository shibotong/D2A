//
//  LiveMatchTimerView.swift
//  D2A
//
//  Created by Shibo Tong on 8/6/2023.
//

import SwiftUI

struct LiveMatchTimerView: View {
    
    var radiantScore: Int?
    var direScore: Int?
    var time: Int?
    
    var radiantTeam: String
    var direTeam: String
    
    private let imagePadding: CGFloat = 20
    
    private var isDayTime: Bool {
        guard let time else {
            return true
        }
        let normalizedSeconds = time % 600 // Normalize the seconds within a 600-second cycle
        
        if normalizedSeconds >= 0 && normalizedSeconds <= 300 {
            return true // Day time
        } else {
            return false // Night time
        }
    }
    
    var body: some View {
        HStack {
            HStack {
                LiveMatchTeamIconView(viewModel: LiveMatchTeamIconViewModel(teamID: radiantTeam, isRadiant: true))
                if let radiantScore {
                    Text("\(radiantScore)")
                        .bold()
                } else {
                    Text("--")
                }
            }
            .padding(imagePadding)
            Spacer()
            VStack {
                Image(systemName: isDayTime ? "sun.min.fill" : "moon.fill")
                    .foregroundColor(isDayTime ? .orange : .blue)
                if let time {
                    Text("\(time.toDuration)")
                        .font(.callout)
                } else {
                    Text("--")
                }
            }
            Spacer()
            HStack {
                if let direScore {
                    Text("\(direScore)")
                        .bold()
                } else {
                    Text("--")
                }
                LiveMatchTeamIconView(viewModel: LiveMatchTeamIconViewModel(teamID: direTeam, isRadiant: false))
            }
            .padding(imagePadding)
        }
    }
}

struct LiveMatchTimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LiveMatchTimerView(radiantScore: 10, direScore: 10, time: -90, radiantTeam: "", direTeam: "")
                .previewLayout(.fixed(width: 300, height: 100))
            LiveMatchTimerView(radiantScore: 10, direScore: 10, time: 100, radiantTeam: "", direTeam: "")
                .previewLayout(.fixed(width: 300, height: 100))
            LiveMatchTimerView(radiantScore: 10, direScore: 10, time: 400, radiantTeam: "", direTeam: "")
                .previewLayout(.fixed(width: 300, height: 100))
            LiveMatchTimerView(radiantScore: nil, direScore: nil, time: nil, radiantTeam: "", direTeam: "")
                .previewLayout(.fixed(width: 300, height: 100))
        }
    }
}
