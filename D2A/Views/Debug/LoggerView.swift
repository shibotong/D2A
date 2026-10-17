//
//  LoggerView.swift
//  D2A
//
//  Created by Shibo Tong on 21/9/2026.
//

import SwiftUI

struct LoggerView: View {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.loggingLevels, id: \.category.rawValue) { viewModel in
                LoggerLevelView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    LoggerView()
}
