import Foundation
import UIKit
import Testing
@testable import D2A

// URLProtocol stub to intercept network requests
final class URLProtocolStub: URLProtocol {
    struct Stub {
        let data: Data
        let response: HTTPURLResponse
        let error: Error?
    }
    static var stubs: [URL: Stub] = [:]
    static var requestCount: [URL: Int] = [:]

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let url = request.url, let stub = URLProtocolStub.stubs[url] else {
            client?.urlProtocol(self, didFailWithError: URLError(.fileDoesNotExist))
            return
        }
        URLProtocolStub.requestCount[url, default: 0] += 1
        if let error = stub.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocol(self, didReceive: stub.response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: stub.data)
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}
}

@Suite("ImageFetcher Tests")
class ImageFetcherTests {

    let base = URL(string: "https://cdn.steamstatic.com/apps/dota2/images/dota_react/heroes")!
    let name = "shredder"
    let imageURL = URL(string: "https://cdn.steamstatic.com/apps/dota2/images/dota_react/heroes")!.appendingPathComponent("shredder.png")

    @Test("Network fetch then memory cache hit")
    @MainActor
    func testMemoryCacheHit() async throws {
        let fetcher = ImageFetcher(baseURL: base, cache: "TestCache_Memory")

        // First fetch (should hit network)
        var firstDelivered = 0
        await fetcher.fetchImage(name: name) { _ in
            firstDelivered += 1
        }
        #expect(firstDelivered >= 1)

        // Second fetch (should hit memory cache and not increase network count)
        var secondDelivered = 0
        await fetcher.fetchImage(name: name) { _ in
            secondDelivered += 1
        }
        #expect(secondDelivered == 1)
        #expect(URLProtocolStub.requestCount[imageURL] == 1)
    }

    @Test("Disk cache delivers before network when memory empty")
    @MainActor
    func testDiskCacheThenNetwork() async throws {
        // Seed disk by one fetch with a dedicated cache directory
        var fetcher: ImageFetcher? = ImageFetcher(baseURL: base, cache: "TestCache_Disk")
        await fetcher!.fetchImage(name: name) { _ in }
        // Drop the instance to clear its memory cache
        fetcher = nil

        // New instance with empty memory cache points to same disk dir
        let newFetcher = ImageFetcher(baseURL: base, cache: "TestCache_Disk")
        var deliveredCount = 0
        await newFetcher.fetchImage(name: name) { _ in
            deliveredCount += 1
        }
        // Expect at least 1 delivery from disk, possibly followed by network (still 1 request overall from stub per call)
        #expect(deliveredCount >= 1)
    }

    @Test("Deduplicates concurrent requests")
    @MainActor
    func testDeduplication() async throws {
        let fetcher = ImageFetcher(baseURL: base, cache: "TestCache_Dedupe")

        // Reset counts
        URLProtocolStub.requestCount[imageURL] = 0

        async let a: Void = fetcher.fetchImage(name: name) { _ in }
        async let b: Void = fetcher.fetchImage(name: name) { _ in }
        _ = try? await (a, b)

        // Only one network request should have been made for the same URL
        #expect(URLProtocolStub.requestCount[imageURL] == 1)
    }
}
