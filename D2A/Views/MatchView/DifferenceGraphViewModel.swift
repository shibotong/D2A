//
//  DifferenceGraphViewModel.swift
//  App
//
//  Created by Shibo Tong on 17/8/21.
//

import Foundation

class DifferenceGraphViewModel: ObservableObject {
    @Published var mins: Double = 0
    var goldDiff: [Int]
    var xpDiff: [Int]
    
    init(goldDiff: [NSNumber], xpDiff: [NSNumber]) {
        self.goldDiff = goldDiff.map { Int(truncating: $0) }
        self.xpDiff = xpDiff.map { Int(truncating: $0) }
        self.mins = Double(goldDiff.count - 1)
    }
}
