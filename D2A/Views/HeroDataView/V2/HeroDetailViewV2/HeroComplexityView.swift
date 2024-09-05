//
//  HeroComplexityView.swift
//  D2A
//
//  Created by Shibo Tong on 30/8/2024.
//

import SwiftUI

struct HeroComplexityView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var color: Color {
        horizontalSizeClass == .compact ? .white : .label
    }
    
    let heroComplexity: Int
    
    var body: some View {
        HStack {
            ForEach(1..<4) { complexity in
                if complexity <= heroComplexity {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 15, height: 15)
                        .foregroundColor(color)
                        .rotationEffect(.degrees(45))
                } else {
                    RoundedRectangle(cornerRadius: 3)
                        .stroke()
                        .frame(width: 15, height: 15)
                        .foregroundColor(color)
                        .rotationEffect(.degrees(45))
                }
            }
        }
    }
}

#Preview {
    HeroComplexityView(heroComplexity: 1)
}
