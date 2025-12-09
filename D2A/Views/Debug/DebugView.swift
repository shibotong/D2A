//
//  DebugView.swift
//  D2A
//
//  Created by Shibo Tong on 6/12/2025.
//

import SwiftUI
import Logging

struct DebugView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(_ loggingCategory: LoggingCategory) {
        viewModel = ViewModel(loggingCategory)
    }
    
    var body: some View {
        Section(viewModel.categoryName) {
            VStack {
                HStack {
                    ForEach(Logger.Level.allCases, id: \.rawValue) { level in
                        Text(level.icon)
                        if level != .critical {
                            Spacer()
                        }
                    }
                }
                Slider(value: $viewModel.levelSlider, in: 0...Double(Logger.Level.allCases.count - 1), step: 1, label: {
                    // This is an issue on iOS 26
                    // https://www.reddit.com/r/SwiftUI/comments/1mm1w3m/ios_26_slider_step_isnt_working/
                    EmptyView()
                }) { editChange in
                    guard !editChange else {
                        // only update logging level when change end
                        return
                    }
                    viewModel.updateLogger()
                }
            }
        }
        .navigationTitle("Console Debug")
    }
}

#Preview {
    List {
        DebugView(.image)
        DebugView(.coredata)
    }
}
