//
//  HeroDetailRow.swift
//  D2A
//
//  Created by Shibo Tong on 27/7/2025.
//

import SwiftUI

struct HeroDetailRow: View {
    
    let title: String
    let value: String
    let color: Color
    
    init(title: String, value: String, color: Color = .label) {
        self.title = title
        self.value = value
        self.color = color
    }
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Rectangle()
                .frame(height: 1)
                .opacity(0.1)
            Text(value)
                .bold()
                .foregroundStyle(color)
        }
    }
}
