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

    let imageFetcher: ImageFetcher
    let name: String
    let fileManager: FileManager
    
    private let cache: String
    private var callCount = 0
    
    init() {
        fileManager = .default
        cache = "UnitTests"
        imageFetcher = ImageFetcher(baseURL: URL(string: "https://cdn.steamstatic.com/apps/dota2/images/dota_react/heroes")!, cache: cache, fileManager: fileManager)
        name = "shredder"
    }
    
    deinit {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheDirectory = caches.appendingPathComponent(cache, isDirectory: true)
        let url = cacheDirectory.appendingPathComponent(name)
        try? fileManager.removeItem(at: url)
    }
    
    @Test
    @MainActor
    func fetchImage() async {
        await callFetchImage()
        #expect(callCount == 1, "First call of image should call once")
        await callFetchImage()
        #expect(callCount == 2, "Second call should fetch image again")
        imageFetcher.resetMemoryCache()
        await callFetchImage()
        #expect(callCount == 4, "After reset, call should fetch image again, call count should be 4")
    }
    
    private func callFetchImage() async {
        await imageFetcher.fetchImage(name: name) { image in
            self.callCount += 1
        }
    }
}
