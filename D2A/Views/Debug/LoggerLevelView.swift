//
//  LoggerLevelView.swift
//  D2A
//
//  Created by Shibo Tong on 21/9/2026.
//

import SwiftUI
import Logging

struct LoggerLevelView: View {
    @ObservedObject var viewModel: LoggingLevel
    @Environment(\.horizontalSizeClass) var horizontalSize
    
    var body: some View {
        HStack {
            Text(viewModel.category.rawValue)
            Spacer()
            if horizontalSize == .regular {
                levelPicker
                    .pickerStyle(.segmented)
            } else {
                levelPicker
                    .pickerStyle(.menu)
            }
        }
        .onChange(of: viewModel.level) { value in
            viewModel.updateCategoryLoggingLevel(level: value)
        }
    }
    
    private var levelPicker: some View {
        Picker(selection: $viewModel.level) {
            ForEach(Logger.Level.allCases, id: \.rawValue) { level in
                Text("\(level.icon) \(level.rawValue.uppercased())")
                    .tag(level)
            }
        } label: {
            Text("Level")
        }
    }
}

class LoggingLevel: ObservableObject {
    @Published var level: Logger.Level
    let category: LoggingCategory
    private let logger: D2ALogger
    
    init(level: Logger.Level, category: LoggingCategory, logger: D2ALogger) {
        self.level = level
        self.category = category
        self.logger = logger
    }
    
    func updateCategoryLoggingLevel(level: Logger.Level) {
        logger.updateLogLevel(category: category, level: level)
    }
}

#Preview {
    LoggerLevelView(viewModel: LoggingLevel(level: .warning, category: .syncing, logger: .shared))
}
