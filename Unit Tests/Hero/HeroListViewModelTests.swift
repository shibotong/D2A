//
//  HeroListViewModelTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 1/7/2025.
//

import XCTest
@testable import D2A

final class HeroListViewModelTests: XCTestCase {
    
    var viewModel: HeroListView.ViewModel!
    var heroes: [Hero]!

    override func setUp() {
        heroes = Hero.previewHeroes
        viewModel = .init(heroes: heroes)
    }

    func testAllHeroesExist() {
        XCTAssertEqual(viewModel.searchedResults.count, heroes.count)
    }
    
    func testSearchHeroesByText() {
        viewModel.searchString = "anti"
        XCTAssertEqual(viewModel.searchedResults.count, 1, "Only one hero can be filtered by text")
        XCTAssertEqual(viewModel.searchedResults.first?.id, 1)
    }
    
    func testSearchHeroesByAttribute() {
        viewModel.selectedAttribute = .agi
        XCTAssertEqual(viewModel.searchedResults.count, 6, "Only 5 heroes are agility")
        viewModel.selectedAttribute = .str
        XCTAssertEqual(viewModel.searchedResults.count, 2, "Only 2 heroes are strength")
        viewModel.selectedAttribute = .int
        XCTAssertEqual(viewModel.searchedResults.count, 1, "Only 1 heroes are intellegence")
        viewModel.selectedAttribute = .uni
        XCTAssertEqual(viewModel.searchedResults.count, 1, "Only 2 heroes are universal")
    }

}
