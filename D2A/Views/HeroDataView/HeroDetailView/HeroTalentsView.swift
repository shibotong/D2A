//
//  HeroTalentsView.swift
//  D2A
//
//  Created by Shibo Tong on 16/4/2026.
//

import SwiftUI

struct HeroTalentsView: View {
    
    let talent10Left: String
    let talent10Right: String
    
    let talent15Left: String
    let talent15Right: String
    
    let talent20Left: String
    let talent20Right: String
    
    let talent25Left: String
    let talent25Right: String
    
    init(talent10Left: String, talent10Right: String, talent15Left: String, talent15Right: String, talent20Left: String, talent20Right: String, talent25Left: String, talent25Right: String) {
        self.talent10Left = talent10Left
        self.talent10Right = talent10Right
        self.talent15Left = talent15Left
        self.talent15Right = talent15Right
        self.talent20Left = talent20Left
        self.talent20Right = talent20Right
        self.talent25Left = talent25Left
        self.talent25Right = talent25Right
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Talents")
                    .font(.system(size: 15))
                    .bold()
                Spacer()
            }.padding(.leading)
            buildTalentLevel(level: 25, left: talent25Left, right: talent25Right)
            Divider()
            buildTalentLevel(level: 20, left: talent20Left, right: talent20Right)
            Divider()
            buildTalentLevel(level: 15, left: talent15Left, right: talent15Right)
            Divider()
            buildTalentLevel(level: 10, left: talent10Left, right: talent10Right)
        }
    }
    
    @ViewBuilder
    private func buildTalentLevel(level: Int, left: String, right: String) -> some View {
        GeometryReader { proxy in
            let talentWidth = (proxy.size.width - 40) / 2
            HStack(spacing: 5) {
                Text(left)
                    .font(.system(size: 10))
                    .frame(width: talentWidth)
                Text("\(level)")
                    .font(.system(size: 10))
                    .bold()
                    .padding(.vertical, 5)
                    .frame(width: 30, height: 30)
                    .background(Circle().stroke().foregroundColor(.yellow))
                Text(right)
                    .font(.system(size: 10))
                    .frame(width: talentWidth)
            }
        }
        .frame(height: 30)
        .padding(.horizontal)
    }
}

#Preview {
    HeroTalentsView(talent10Left: "10 left", talent10Right: "10 right", talent15Left: "15 left", talent15Right: "15 right", talent20Left: "20 left", talent20Right: "20 right", talent25Left: "25 left", talent25Right: "25 right")
}
