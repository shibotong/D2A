//
//  HeroSyncingView.swift
//  D2A
//
//  Created by Shibo Tong on 25/4/2026.
//

import SwiftUI

struct HeroSyncingView: View {
    
    let currentProcess: Int
    let totalProcess: Int
    let progress: Double
    
    var body: some View {
        VStack {
            HStack {
                ProgressView()
                Text("Fetching constant data (\(currentProcess)/\(totalProcess))")
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
    HeroSyncingView(currentProcess: 1, totalProcess: 5, progress: 0.5)
}
