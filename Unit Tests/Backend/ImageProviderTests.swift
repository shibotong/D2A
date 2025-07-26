//
//  ImageProviderTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 16/6/2025.
//

import XCTest
@testable import D2A

final class ImageProviderTests: XCTestCase {

    var imageProvider: ImageProvider!
    let imageType: GameImageType = .item
    let imageID: String = "1"
    var directory: URL!

    override func setUp() {
        directory = FileManager.default.temporaryDirectory
        imageProvider = ImageProvider(directory: directory)
    }

    override func tearDown() {
        let path = directory.appendingPathComponent(imageType.folder).appendingPathComponent(imageID).appendingPathExtension("jpg")
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: path)
    }

    func testImageSaving() async {
        if imageProvider.localImage(type: imageType, id: imageID, fileExtension: .jpg) != nil {
            XCTFail("No image should be saved at beginning")
            return
        }
        guard let remoteImage = await imageProvider.remoteImage(url: "https://picsum.photos/200/300") else {
            XCTFail("Remote image should not be nil")
            return
        }
        try? imageProvider.saveImage(image: remoteImage, type: imageType, id: imageID, fileExtension: .jpg)

        let savedImage = imageProvider.localImage(type: imageType, id: imageID, fileExtension: .jpg)
        XCTAssertNotNil(savedImage, "Image should be fetched locally")
    }

}
