//
//  HUDView.swift
//  D2A
//
//  Created by Shibo Tong on 4/11/2025.
//

import SwiftUI

#if DEBUG
struct HUDView: View {
    
    @ObservedObject var progress: HUDProgress
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(progress.title)
            ProgressView(value: Double(progress.current) / Double(progress.total)) {
                Text("\(progress.current) / \(progress.total)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .progressViewStyle(.linear)
        }
    }
}

#Preview {
    HUDView(progress: HUDProgress(title: "TEST HUD", total: 100, current: 1))
}
#endif
