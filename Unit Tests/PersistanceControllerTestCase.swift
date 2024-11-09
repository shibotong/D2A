//
//  PersistanceControllerTestCase.swift
//  Unit Tests
//
//  Created by Mac mini Server on 9/11/2024.
//

import XCTest
@testable import D2A

final class PersistanceControllerTestCase: XCTestCase {
    
    var persistenceController: PersistenceController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        persistenceController = PersistenceController(inMemory: true)
    }

    func testInsertHero() async throws {
        let hero = HeroCodable(heroID: 1, name: "Test Hero")
        try await persistenceController.insertHeroes(heroes: [hero])
        let predicate = NSPredicate(format: "%K = %K", #keyPath(Hero.heroID), 1)
        let context = persistenceController.container.viewContext
        let savedHero = persistenceController.fetchOne(for: Hero.self, predicate: predicate, context: context)
        XCTAssertEqual(savedHero?.heroID, 1)
        XCTAssertEqual(savedHero?.name, "Test Hero")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
