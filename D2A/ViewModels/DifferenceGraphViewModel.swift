//
//  DifferenceGraphViewModel.swift
//  App
//
//  Created by Shibo Tong on 17/8/21.
//

import Foundation

class DifferenceGraphViewModel: ObservableObject {
    @Published var mins: Double = 0
    var goldDiff: [Int]?
    var xpDiff: [Int]?
    
    init(goldDiff: [Int]?, xpDiff: [Int]?) {
        self.goldDiff = goldDiff
        self.xpDiff = xpDiff
        if goldDiff != nil && xpDiff != nil {
            self.mins = Double(goldDiff!.count - 1)
        } else {
            self.mins = 0
        }
    }
}
