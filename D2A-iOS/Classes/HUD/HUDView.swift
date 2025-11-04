//
//  HUDView.swift
//  D2A
//
//  Created by Shibo Tong on 4/11/2025.
//

import SwiftUI

#if DEBUG
struct HUDView: View {
    
    @State var title: String
    @State var processed: Int
    @State var total: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            ProgressView(value: Double(processed) / Double(total)) {
                Text("\(processed) / \(total)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .progressViewStyle(.linear)
        }
    }
}

#Preview {
    HUDView(title: "Test HUD", processed: 1, total: 100)
}
#endif
