//
//  OpenDotaProviderTests.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

import Testing
@testable import D2A

@Suite("OpenDotaProvider tests")
struct OpenDotaProviderTests {
    
    let provider: OpenDotaProvider
    let network: MockNetwork
    
    init() {
        network = MockNetwork()
        provider = OpenDotaProvider(network: network)
    }
}
