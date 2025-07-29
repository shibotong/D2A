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
            Spacer()
                .overlay {
                    VStack {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            Text(value)
                .bold()
                .foregroundStyle(color)
        }
    }
}

#if DEBUG
#Preview {
    HeroDetailRow(title: "veryverylongTextveryverylongText", value: "100", color: .label)
}
#endif
