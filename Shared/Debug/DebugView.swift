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
            Slider(value: $logger.logging, in: 0...4, step: 1) {
                Text("Logger")
            }
            HStack {
                Text(LoggingLevel.info.icon)
                ForEach(LoggingLevel.allCases, id: \.icon) { level in
                    if level != .info {
                        Spacer()
                        Text(level.icon)
                    }
                }
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
