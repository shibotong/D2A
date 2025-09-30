//
//  MatchTimerView.swift
//  D2A
//
//  Created by Shibo Tong on 20/9/2025.
//

import SwiftUI

extension MatchViewV2 {
    struct Banner: View {
        
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
        
        var radiantScore: Int
        var direScore: Int
        var time: Int
        
        var radiantTeamID: String?
        var direTeamID: String?
        var radiantTeamName: String?
        var direTeamName: String?
        
        var radiantWin: Bool
        
        private let imagePadding: CGFloat = 20
        private var teamIconSize: CGFloat {
            if horizontalSizeClass == .compact {
                return 48
            } else {
                return 64
            }
        }
        
        private var isDayTime: Bool {
            let normalizedSeconds = time % 600  // Normalize the seconds within a 600-second cycle
            return normalizedSeconds >= 0 && normalizedSeconds <= 300
        }
        
        var body: some View {
            ZStack {
                HStack {
                    HStack {
                        buildIcon(isRadiant: true, teamID: radiantTeamID, win: radiantWin)
                        if horizontalSizeClass == .regular {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(radiantTeamName ?? "Radiant")
                                    .font(.largeTitle)
                                    .bold()
                                buildWinLoss(win: radiantWin, isRadiant: true)
                            }
                        }
                    }
                    Spacer()
                    HStack {
                        if horizontalSizeClass == .regular {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(direTeamName ?? "Dire")
                                    .font(.largeTitle)
                                    .bold()
                                buildWinLoss(win: !radiantWin, isRadiant: false)
                            }
                        }
                        buildIcon(isRadiant: false, teamID: direTeamID, win: !radiantWin)
                    }
                }
                score
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color(UIColor.systemGreen), Color(UIColor.systemRed)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .opacity(0.3)
            )
        }
        
        private var score: some View {
            HStack {
                buildScore(score: radiantScore)
                VStack {
                    Image(systemName: isDayTime ? "sun.min.fill" : "moon.fill")
                        .foregroundColor(isDayTime ? .orange : .blue)
                    Text("\(time.toDuration)")
                        .font(.callout)
                }
                buildScore(score: direScore)
            }
        }
        
        @ViewBuilder
        private func buildIcon(isRadiant: Bool, teamID: String?, win: Bool) -> some View {
            TeamIcon(isRadiant: isRadiant, teamID: teamID)
                .frame(width: teamIconSize, height: teamIconSize)
                .overlay {
                    if win {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("W")
                                    .font(.caption)
                                    .bold()
                                    .padding(2)
                                    .background(Color(uiColor: .systemGreen))
                            }
                        }
                    }
                }
        }
        
        @ViewBuilder
        private func buildScore(score: Int) -> some View {
            Text("\(score)")
                .bold()
                .font(.title)
        }
        
        @ViewBuilder
        private func buildWinLoss(win: Bool, isRadiant: Bool) -> some View {
            Text(win ? "Won" : "Lost")
                .bold()
                .padding(.horizontal, 10)
                .background(win ? Color(uiColor: isRadiant ? .systemGreen : .systemRed) : Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

#Preview {
    typealias Banner = MatchViewV2.Banner
    return Banner(radiantScore: 10, direScore: 10, time: 100, radiantTeamID: "", direTeamID: "", radiantWin: true)
        .environmentObject(EnvironmentController.preview)
}
