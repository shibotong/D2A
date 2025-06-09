//
//  DebugView.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

import SwiftUI

struct DebugView: View {

    @EnvironmentObject var logger: D2ALogger

    var body: some View {
        List {
            Slider(value: $logger.logging, in: 0...2, step: 1) {
                Text("Logger")
            }
            HStack {
                Text("📝")
                Spacer()
                Text("⚠️")
                Spacer()
                Text("❌")
            }
        }
        .navigationTitle("Console Logging")
    }
}

#Preview {
    NavigationView {
        DebugView()
    }
    .environmentObject(D2ALogger())
}
