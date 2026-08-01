//
//  AbilityImageViewModelTests.swift
//  D2A
//
//  Created by Shibo Tong on 1/8/2026.
//

import Testing
import TestKit
@testable import D2A

struct AbilityImageViewModelTests {
    
    private let imageProvider: ImageProvidingMock
    private let client: MockAPIClient
    
    init() {
        imageProvider = ImageProvidingMock()
        client = MockAPIClient()
    }
    
    @Test("No ability image when no cached image")
    func testImageNotExist() async {
        imageProvider._read.implementation = .returns(nil)
        let viewModel = createViewModel()
        #expect(viewModel.image == nil)
        #expect(imageProvider._read.callCount == 1)
    }
    
    private func createViewModel(name: String = "test-image") -> AbilityImage.ViewModel {
        return AbilityImage.ViewModel(name: "test-image",
                                      imageProvider: imageProvider,
                                      client: client,
                                      logger: logger)
    }
}
