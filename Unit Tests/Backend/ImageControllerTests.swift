//
//  FileControllerTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 14/6/2025.
//

import XCTest
@testable import D2A

class MockImageProvider: ImageProviding {
    
    var remoteImageCalled: Int = 0
    var localImageCalled: Int = 0
    var saveImageCalled: Int = 0
    
    func remoteImage(url: String) async -> UIImage? {
        remoteImageCalled += 1
        return UIImage()
    }
    
    func localImage(type: D2A.ImageCacheType, id: String, fileExtension: D2A.ImageExtension) -> UIImage? {
        localImageCalled += 1
        if localImageCalled == 1 {
            return nil
        }
        return UIImage()
    }
    
    func saveImage(image: UIImage, type: D2A.ImageCacheType, id: String, fileExtension: D2A.ImageExtension) {
        saveImageCalled += 1
    }
}

final class ImageControllerTests: XCTestCase {
    
    var imageController: ImageController!
    var userDefaults: UserDefaults!
    var imageProvider: MockImageProvider!
    var imageHandlerCalled: Int!
    
    private let heroCache: ImageCacheType = .hero
    private let heroID: String = "1"
    
    override func setUp()  {
        imageProvider = MockImageProvider()
        userDefaults = UserDefaults(suiteName: "UnitTest")!
        imageController = ImageController(imageProvider: imageProvider, userDefaults: userDefaults)
        imageHandlerCalled = 0
    }
    
    override func tearDown() {
        userDefaults.set(nil, forKey: "\(heroCache.rawValue)_\(heroID)")
    }
    
    func testLoadImageAtBeginning() async {
        let currentDate = Date()
        await callRefreshImage(time: currentDate)
        XCTAssertEqual(imageHandlerCalled, 1, "First time call should render image once")
        
        XCTAssertEqual(imageProvider.localImageCalled, 1, "First time call should fetch local image")
        XCTAssertEqual(imageProvider.remoteImageCalled, 1, "First time call should fetch remote image")
        XCTAssertEqual(imageProvider.saveImageCalled, 1, "First time call should save image")
        
        await callRefreshImage(time: currentDate.addComponent(second: 1))
        XCTAssertEqual(imageHandlerCalled, 2, "Second time call on same day should render image once again")
        
        XCTAssertEqual(imageProvider.localImageCalled, 2, "Second time call on same day should fetch local image")
        XCTAssertEqual(imageProvider.remoteImageCalled, 1, "Second time call on same day should not fetch remote image")
        XCTAssertEqual(imageProvider.saveImageCalled, 1, "Second time call on same day should not save image")
        
        await callRefreshImage(time: currentDate.addComponent(day: 1))
        XCTAssertEqual(imageHandlerCalled, 4, "Third time call on different day should render image twice")
        
        XCTAssertEqual(imageProvider.localImageCalled, 3, "Third time call on different day should fetch local image")
        XCTAssertEqual(imageProvider.remoteImageCalled, 2, "Third time call on different day should fetch remote image")
        XCTAssertEqual(imageProvider.saveImageCalled, 2, "Third time call on different day should save image")
    }
    
    private func callRefreshImage(time: Date) async {
        await imageController.refreshImage(type: .hero, id: "1", url: "https://picsum.photos/200/300", refreshTime: time) { _ in
            imageHandlerCalled += 1
        }
    }
}
