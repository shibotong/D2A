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
    let size: CGFloat
    
    init(heroID: Int, playerWin: Bool, size: CGFloat = 15) {
        self.heroID = heroID
        self.playerWin = playerWin
        self.size = size
    }
    
    var body: some View {
        VStack {
            HeroImageView(heroID: heroID, type: .icon)
                .frame(width: size, height: size)
            WinLossView(win: playerWin, size: size * 0.75)
        }
    }
}

struct WinLossView: View {
    
    let win: Bool
    let size: CGFloat
    
    init(win: Bool, size: CGFloat = 15) {
        self.win = win
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(win ? Color(.systemGreen) : Color(.systemRed))
                .frame(width: size, height: size)
            Text("\(win ? "W" : "L")").font(.caption).bold().foregroundColor(.white)
        }
    }
}

struct RecentMatchWinLossView_Previews: PreviewProvider {
    static var previews: some View {
        RecentMatchWinLossView(heroID: 1, playerWin: true)
    }
}
