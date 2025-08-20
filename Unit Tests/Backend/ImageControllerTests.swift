//
//  ImageControllerTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 16/6/2025.
//

import XCTest
@testable import D2A

class MockImageProvider: ImageProviding {
    
    var remoteImageCalled: Int = 0
    var localImageCalled: Int = 0
    var saveImageCalled: Int = 0
    
    var remoteImageReturn: UIImage?
    var localImageReturn: UIImage?
    var error: D2AError?
    
    func remoteImage(url: String) async -> UIImage? {
        remoteImageCalled += 1
        return remoteImageReturn
    }
    
    func localImage(type: D2A.GameImageType, id: String, fileExtension: D2A.ImageExtension) -> UIImage? {
        localImageCalled += 1
        return localImageReturn
    }
    
    func saveImage(image: UIImage, type: D2A.GameImageType, id: String, fileExtension: D2A.ImageExtension) throws {
        saveImageCalled += 1
        if let error {
            throw error
        }
    }
}

final class EnvironmentControllerTests: XCTestCase {
    
    var environment: EnvironmentController!
    var userDefaults: UserDefaults!
    var imageProvider: MockImageProvider!
    var imageHandlerCalled: Int!
    var cache: ImageCache!
    
    private let heroCache: GameImageType = .avatar
    private let heroID: String = "1"
    
    override func setUp()  {
        imageProvider = MockImageProvider()
        cache = ImageCache()
        userDefaults = UserDefaults.standard
        environment = EnvironmentController(imageProvider: imageProvider, imageCache: cache, userDefaults: userDefaults)
        imageHandlerCalled = 0
    }
    
    override func tearDown() {
        userDefaults.set(nil, forKey: "\(heroCache.folder)_\(heroID)")
    }
    
    func testWithNoLocalImage() async throws {
        let currentDate = Date()
        imageProvider.remoteImageReturn = UIImage()
        try await callRefreshImage(time: currentDate)
        XCTAssertEqual(imageHandlerCalled, 1, "Remote image exist and local image not exist should render once for remote image")
        XCTAssertEqual(imageProvider.localImageCalled, 1, "Local image function should be called once")
        XCTAssertEqual(imageProvider.remoteImageCalled, 1, "Remote image function should be called once")
        XCTAssertEqual(imageProvider.saveImageCalled, 1, "Save image function should be called once")
    }
    
    func testWithLocalAndRemoteImage() async throws {
        let currentDate = Date()
        imageProvider.remoteImageReturn = UIImage()
        imageProvider.localImageReturn = UIImage()
        try await callRefreshImage(time: currentDate)
        XCTAssertEqual(imageHandlerCalled, 2, "Both local image and remote image exist should render twice")
        XCTAssertEqual(imageProvider.localImageCalled, 1, "Local image function should be called once")
        XCTAssertEqual(imageProvider.remoteImageCalled, 1, "Remote image function should be called once")
        XCTAssertEqual(imageProvider.saveImageCalled, 1, "Save image function should be called once")
    }
    
    func testWithNoRemoteImage() async throws {
        let currentDate = Date()
        imageProvider.localImageReturn = UIImage()
        try await callRefreshImage(time: currentDate)
        XCTAssertEqual(imageHandlerCalled, 1, "Local image exist and remote image not exist should render once for local image")
        XCTAssertEqual(imageProvider.localImageCalled, 1, "Local image function should be called once")
        XCTAssertEqual(imageProvider.remoteImageCalled, 1, "Remote image function should be called once")
        XCTAssertEqual(imageProvider.saveImageCalled, 0, "Save image function should not be called as no remote image")
    }
    
    func testLoadImageWithCache() async throws {
        let currentDate = Date()
        
        // Remote image available
        imageProvider.remoteImageReturn = UIImage()
        try await callRefreshImage(time: currentDate)
        XCTAssertEqual(imageHandlerCalled, 1, "First time call should render image once")
        XCTAssertEqual(imageProvider.localImageCalled, 1, "First time call should fetch local image")
        XCTAssertEqual(imageProvider.remoteImageCalled, 1, "First time call should fetch remote image")
        XCTAssertEqual(imageProvider.saveImageCalled, 1, "First time call should save image")
        
        // Local imag available
        imageProvider.localImageReturn = UIImage()
        try await callRefreshImage(time: currentDate.addComponent(second: 1))
        XCTAssertEqual(imageHandlerCalled, 2, "Second time call on same session should render image once again")
        XCTAssertEqual(imageProvider.localImageCalled, 1, "Second time call on same session should fetch image from cache")
        XCTAssertEqual(imageProvider.remoteImageCalled, 1, "Second time call on same day should not fetch remote image")
        XCTAssertEqual(imageProvider.saveImageCalled, 1, "Second time call on same day should not save image")
        
        await cache.resetCache()
        
        try await callRefreshImage(time: currentDate.addComponent(second: 1))
        XCTAssertEqual(imageHandlerCalled, 3, "Second time call on same day should render image once again")
        
        XCTAssertEqual(imageProvider.localImageCalled, 2, "Second time call on same day should fetch local image")
        XCTAssertEqual(imageProvider.remoteImageCalled, 1, "Second time call on same day should not fetch remote image")
        XCTAssertEqual(imageProvider.saveImageCalled, 1, "Second time call on same day should not save image")
        
        await cache.resetCache()
        
        try await callRefreshImage(time: currentDate.addComponent(day: 1))
        XCTAssertEqual(imageHandlerCalled, 5, "Third time call on different day should render image twice")
        XCTAssertEqual(imageProvider.localImageCalled, 3, "Third time call on different day should fetch local image")
        XCTAssertEqual(imageProvider.remoteImageCalled, 2, "Third time call on different day should fetch remote image")
        XCTAssertEqual(imageProvider.saveImageCalled, 2, "Third time call on different day should save image")
    }
    
    func testLocalImageCall() {
        let image = UIImage()
        imageProvider.localImageReturn = image
        let localImage = imageProvider.localImage(type: .avatar, id: "1", fileExtension: .png)
        XCTAssertEqual(image, localImage, "Image should be returned for local image call")
    }
    
    func testSavingError() async {
        imageProvider.remoteImageReturn = UIImage()
        imageProvider.error = D2AError(message: "Test Error")
        do {
            try await callRefreshImage(time: Date())
            XCTFail("Error should be thrown")
        } catch {
            XCTAssertEqual(error.localizedDescription, "Test Error")
        }
    }
    
    private func callRefreshImage(time: Date) async throws {
        try await environment.refreshImage(type: .avatar, id: "1", url: "https://picsum.photos/200/300", refreshTime: time) { _ in
            imageHandlerCalled += 1
        }
    }
}
