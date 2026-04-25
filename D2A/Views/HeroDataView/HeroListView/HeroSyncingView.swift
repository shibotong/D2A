//
//  HeroSyncingView.swift
//  D2A
//
//  Created by Shibo Tong on 25/4/2026.
//

import SwiftUI

struct HeroSyncingView: View {
    
    let service: String
    let progress: Double
    
    var body: some View {
        VStack {
            HStack {
                ProgressView()
                Text("Current syncing \(service)")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .frame(width: 200)
        }
    }
}

#Preview {
    HeroSyncingView(service: "abilities", progress: 0.5)
}
