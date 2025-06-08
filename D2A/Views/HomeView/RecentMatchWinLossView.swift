//
//  RecentMatchWinLossView.swift
//  D2A
//
//  Created by Shibo Tong on 29/1/2023.
//

import SwiftUI

struct RecentMatchWinLossView: View {
    
    let heroID: Int
    let playerWin: Bool
    
    init(heroID: Int, playerWin: Bool) {
        self.heroID = heroID
        self.playerWin = playerWin
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HeroImageView(heroID: heroID, type: .icon)
            WinLossView(win: playerWin)
        }
    }
}

struct WinLossView: View {
    
    let win: Bool
    
    init(win: Bool) {
        self.win = win
    }
    
    var body: some View {
        GeometryReader { proxy in
            let sideLength = proxy.size.width * 5 / 6
            Text("\(win ? "W" : "L")")
                .font(.caption2)
                .bold()
                .foregroundColor(.white)
                .background(Rectangle()
                    .frame(width: sideLength, height: sideLength, alignment: .center)
                    .foregroundColor(win ? Color(.systemGreen) : Color(.systemRed)))
                .frame(width: proxy.size.width, height: proxy.size.width)
        }
    }
}

struct RecentMatchWinLossView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            RecentMatchWinLossView(heroID: 1, playerWin: true)
                .frame(width: 10)
            RecentMatchWinLossView(heroID: 1, playerWin: false)
                .frame(width: 20)
        }
    }
}
