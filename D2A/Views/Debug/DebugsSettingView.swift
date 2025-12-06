//
//  DebugsSettingView.swift
//  D2A
//
//  Created by Shibo Tong on 6/12/2025.
//

import SwiftUI

struct DebugsSettingView: View {
    var body: some View {
        List {
            ForEach(LoggingCategory.allCases, id: \.rawValue) { category in
                DebugView(category)
            }
        }
    }
}

#Preview {
    DebugsSettingView()
}
