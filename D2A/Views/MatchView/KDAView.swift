//
//  KDAView.swift
//  App
//
//  Created by Shibo Tong on 13/10/21.
//

import SwiftUI

struct KDAView: View {
    var kills: Int
    var deaths: Int
    var assists: Int
    var size: Font
    var body: some View {
        HStack(spacing: 0) {
            Text("\(kills)").bold()
            Text("/\(deaths)").lineLimit(1).foregroundColor(Color(.systemRed))
            Text("/\(assists)").lineLimit(1)
            Text(" (\(calculateKDA().rounded(toPlaces: 1).description))").bold().foregroundColor(Color(.systemGray))
        }.font(size).foregroundColor(.label)
    }
    
    private func calculateKDA() -> Double {
        if deaths == 0 {
            return Double(kills + assists)
        } else {
            return Double(kills + assists) / Double(deaths)
        }
    }
}
