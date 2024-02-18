//
//  TeamHeaderView.swift
//  D2A
//
//  Created by Shibo Tong on 18/2/2024.
//

import SwiftUI

struct TeamHeaderView: View {
    var isRadiant: Bool
    var win: Bool
    var teamName: String?
    
    private var teamString: String {
        return isRadiant ? "Radiant" : "Dire"
    }
    
    var body: some View {
        HStack {
            Image("icon_\(teamString.lowercased())")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            HStack {
                Text(LocalizedStringKey(teamName ?? teamString))
                    .font(.system(size: 15))
                    .bold()
                Text("\(win ? "🏆" : "")")
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

#Preview {
    TeamHeaderView(isRadiant: true, win: true)
}
