//
//  DataHelperTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 8/8/2025.
//

import Testing
import SwiftUI
@testable import D2A

struct DataHelperTests {

    @Test(arguments: [0, nil])
    func testRankUnranked(rank: Int?) {
        let rankName = DataHelper.transferRank(rank: rank)
        #expect(rankName == "Unranked")
    }
    
    @Test
    func testRankHerald() {
        let rankName = DataHelper.transferRank(rank: 11)
        #expect(rankName == "Herald I")
    }

    @Test
    func testRankGuardian() {
        let rankName = DataHelper.transferRank(rank: 22)
        #expect(rankName == "Guardian II")
    }
    
    @Test
    func testRankCrusader() {
        let rankName = DataHelper.transferRank(rank: 33)
        #expect(rankName == "Crusader III")
    }
    
    @Test
    func testRankArchon() {
        let rankName = DataHelper.transferRank(rank: 44)
        #expect(rankName == "Archon IV")
    }
    
    @Test
    func testRankLegend() {
        let rankName = DataHelper.transferRank(rank: 55)
        #expect(rankName == "Legend V")
    }
    
    @Test
    func testRankAncient() {
        let rankName = DataHelper.transferRank(rank: 61)
        #expect(rankName == "Ancient I")
    }
    
    @Test
    func testRankDevine() {
        let rankName = DataHelper.transferRank(rank: 71)
        #expect(rankName == "Divine I")
    }
    
    @Test
    func testRankImmortal() {
        let rankName = DataHelper.transferRank(rank: 80)
        #expect(rankName == "Immortal")
    }

}
