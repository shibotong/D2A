//
//  DebugViewTests.swift
//  D2A
//
//  Created by Shibo Tong on 6/12/2025.
//

import Testing
@testable import D2A

struct DebugViewTests {
    let viewModel = DebugView.ViewModel(.coredata)
    
    @Test("Debug view tests", arguments: LoggingCategory.allCases)
    func debugView(category: LoggingCategory) async throws {
        let viewModel = DebugView.ViewModel(category)
        #expect(viewModel.categoryName == category.rawValue)
        #expect(viewModel.levelSlider == 1)
        
        viewModel.levelSlider = 2
        viewModel.updateLogger()
        #expect(category.logger.logLevel == .info)
    }
}
