//
//  LeagueNodeDefaultGroupEnum.swift
//  D2A
//
//  Created by Shibo Tong on 26/10/2022.
//

import Foundation

extension LeagueNodeDefaultGroupEnum {
    var totalWins: Int {
        switch self {
        case .bestOfFive:
            return 3
        case .bestOfTwo, .bestOfThree:
            return 2
        case .bestOfOne:
            return 1
        default:
            return 0
        }
    }
}
