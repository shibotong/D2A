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
        VStack {
            HeroImageView(heroID: heroID, type: .icon)
            WinLossView(win: playerWin)
        }
        .frame(width: 25)
    }
}

struct WinLossView: View {
    
    let win: Bool
    
    init(win: Bool) {
        self.win = win
    }
    
    var body: some View {
        Text("\(win ? "W" : "L")")
            .font(.caption)
            .bold()
            .foregroundColor(.white)
            .padding(3)
            .background(Rectangle().foregroundColor(win ? Color(.systemGreen) : Color(.systemRed)))
    }
}

struct RecentMatchWinLossView_Previews: PreviewProvider {
    static var previews: some View {
        RecentMatchWinLossView(heroID: 1, playerWin: true)
    }
}
