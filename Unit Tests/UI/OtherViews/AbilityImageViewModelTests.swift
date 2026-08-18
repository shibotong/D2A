//
//  AbilityImageViewModelTests.swift
//  D2A
//
//  Created by Shibo Tong on 1/8/2026.
//

import Testing
import TestKit
import UIKit
@testable import D2A

class AbilityImageViewModelTests {
    
    private let imageProvider: ImageProvidingMock
    private let client: MockAPIClient
    
    init() {
        imageProvider = ImageProvidingMock()
        client = MockAPIClient()
    }
    
    @Test("No ability image when no cached image")
    func testImageNotExist() {
        imageProvider._read.implementation = .returns(nil)
        let viewModel = createViewModel()
        #expect(viewModel.image == nil)
        #expect(imageProvider._read.callCount == 1)
    }
    
    @Test("When image already cached before")
    func testImageExist() {
        let image = UIImage()
        imageProvider._read.implementation = .returns(image)
        let viewModel = createViewModel()
        #expect(viewModel.image == image)
        #expect(imageProvider._read.callCount == 1)
    }
    
    @Test("Test fetching image from remote")
    func testFetchImage() async throws {
        imageProvider._read.implementation = .returns(nil)
        let image = UIImage(systemName: "person")
        client.getReturnValue = image!.pngData()!
        let viewModel = createViewModel()
        await #expect(throws: Never.self) {
            try await viewModel.fetchImage()
        }
    }
    
    @Test("Test fetching image from remote with error")
    func testFetchImageError() async {
        imageProvider._read.implementation = .returns(nil)
        client.getReturnValue = "error".data(using: .utf8)!
        let viewModel = createViewModel()
        let error = await #expect(throws: D2AError.self) {
            try await viewModel.fetchImage()
        }
        #expect(error?.category == .image)
    }
    
    private func createViewModel(name: String = "test-image") -> AbilityImage.ViewModel {
        return AbilityImage.ViewModel(name: "test-image",
                                      imageProvider: imageProvider,
                                      client: client)
    }
}
