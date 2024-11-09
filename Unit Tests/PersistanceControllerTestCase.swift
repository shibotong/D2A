//
//  PersistanceControllerTestCase.swift
//  Unit Tests
//
//  Created by Mac mini Server on 9/11/2024.
//

import XCTest
@testable import D2A

final class PersistanceControllerTestCase: XCTestCase {
    
    var persistenceController: PersistenceController

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        persistenceController = PersistenceController(inMemory: true)
    }

    func testInsertHero() throws {
        let hero = HeroCodable(id: 1, name: "Test", description: "Test")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
