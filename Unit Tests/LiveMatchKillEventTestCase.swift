//
//  LiveMatchKillEventTestCase.swift
//  D2ATests
//
//  Created by Shibo Tong on 11/6/2023.
//

@testable import D2A
import XCTest

final class LiveMatchKillEventTestCase: XCTestCase {
    
    private var players: LiveMatchPlayers!

    override func setUp() {
        players = .init(radiant: [1, 2, 3, 4, 5], dire: [6, 7, 8, 9, 10])
    }

    func testGenerateSingleKillEvent() {
        let killEvent = LiveMatchKillEvent(time: 0, kill: [1], died: [6, 7], players: players)
        let events = killEvent.generateEvent()
        XCTAssertEqual(events.count, 1)
        
        XCTAssertEqual(events.first!.isRadiantEvent, true)
        
        XCTAssertEqual(events.first!.events.count, 2)
        
        XCTAssertEqual(events.first!.events.map { $0.type }, [.killDied, .killDied])
    }
    
    func testGenerateTwoSideKillEvent() {
        let killEvent = LiveMatchKillEvent(time: 0, kill: [1, 6], died: [1, 6, 7], players: players)
        let events = killEvent.generateEvent()
        
        XCTAssertEqual(events.count, 2)
        
        let radiantKillEvents = events.filter({ $0.isRadiantEvent })
        let direKillEvents = events.filter({ !$0.isRadiantEvent })
        XCTAssertEqual(radiantKillEvents.count, 1)
        XCTAssertEqual(direKillEvents.count, 1)
        
        XCTAssertEqual(radiantKillEvents.first!.events.count, 2)
        XCTAssertEqual(direKillEvents.first!.events.count, 1)
    }
    
    func testGenerateMultipleKillEvent() {
        let killEvent = LiveMatchKillEvent(time: 0, kill: [1, 2, 6], died: [1, 6, 7, 8], players: players)
        let events = killEvent.generateEvent()
        
        XCTAssertEqual(events.count, 6)
        let radiantEvents = events.filter({ $0.isRadiantEvent })
        let direEvents = events.filter({ !$0.isRadiantEvent })
        XCTAssertEqual(radiantEvents.count, 5)
        XCTAssertEqual(direEvents.count, 1)
        
        direEvents.forEach { event in
            XCTAssertEqual(event.events.first!.type, .killDied)
        }
    }

}
