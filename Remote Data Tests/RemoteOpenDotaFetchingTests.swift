//
//  RemoteOpenDotaFetchingTests.swift
//  D2A
//
//  Created by Shibo Tong on 5/7/2026.
//

import Testing
@testable import OpenDota
import Foundation

struct RemoteOpenDotaFetcherTests {
    
    let fetcher: OpenDotaFetching
    
    init() {
        fetcher = OpenDotaFetcher()
    }
    
    @Test
    func `Yatoro profile`() async {
        await #expect(throws: Never.self) {
            let _ = try await fetcher.profile(id: "321580662")
        }
    }
    
    @Test
    func `Not Found Profiles`() async {
        await #expect(throws: URLError.notFound) {
            let _ = try await fetcher.profile(id: "123123131")
        }
    }
}
