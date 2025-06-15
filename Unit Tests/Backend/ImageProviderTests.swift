//
//  ImageProviderTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 15/6/2025.
//

import XCTest
@testable import D2A

final class ImageProviderTests: XCTestCase {
    
    var imageProvider: ImageProvider!
    let imageType: ImageCacheType = .hero
    let imageID: String = "1"

    override func setUp() {
        imageProvider = ImageProvider()
    }
    
    override func tearDown() {
        guard let docDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME) else {
            return
        }
        let path = docDir.appendingPathComponent(imageType.rawValue).appendingPathComponent(imageID).appendingPathExtension("jpg")
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: path)
    }

    func testImageSaving() async {
        if let localImage = imageProvider.localImage(type: imageType, id: imageID, fileExtension: .jpg) {
            XCTFail("No image should be saved at beginning")
            return
        }
        guard let remoteImage = await imageProvider.remoteImage(url: "https://picsum.photos/200/300") else {
            XCTFail("Remote image should not be nil")
            return
        }
        imageProvider.saveImage(image: remoteImage, type: imageType, id: imageID, fileExtension: .jpg)
        
        let savedImage = imageProvider.localImage(type: imageType, id: imageID, fileExtension: .jpg)
        XCTAssertNotNil(savedImage, "Image should be fetched locally")
    }

}
