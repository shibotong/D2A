//
//  ImageFetcher.swift
//  D2A
//
//  Created by Assistant on 30/11/2025.
//

import Foundation
import UIKit
import CryptoKit
import os.log

// Actor to manage in-flight requests to deduplicate concurrent fetches for the same key
actor InFlightRequests {
    private var tasks: [String: Task<UIImage, Error>] = [:]

    func task(for key: String) -> Task<UIImage, Error>? {
        tasks[key]
    }

    func set(task: Task<UIImage, Error>, for key: String) {
        tasks[key] = task
    }

    func removeTask(for key: String) {
        tasks.removeValue(forKey: key)
    }
}

final class ImageFetcher {
    static let fullFetcher = ImageFetcher(baseURL: URL(string: "https://cdn.steamstatic.com/apps/dota2/images/dota_react/heroes")!, cache: "HeroImageFull")
    static let vertFetcher = ImageFetcher(baseURL: URL(string: "https://cdn.stratz.com/images/dota2/heroes")!, cache: "HeroImageVert", postfix: "_vert")
    static let iconFetcher = ImageFetcher(baseURL: URL(string: "https://cdn.stratz.com/images/dota2/heroes")!, cache: "HeroImageIcon", postfix: "_icon")

    private let baseURL: URL
    private let fileManager: FileManager
    private let inFlight = InFlightRequests()
    private var memoryCache: [String: UIImage] = [:]
    private let imagePostFix: String

    // Directory for disk cache
    private let cacheDirectory: URL

    // Configure with a base URL. Default can be your API root; override as needed.
    public init(baseURL: URL,
                cache: String,
                postfix: String = "",
                fileManager: FileManager = .default) {
        self.baseURL = baseURL
        self.fileManager = fileManager
        self.imagePostFix = postfix
        // Create a subdirectory inside Caches for images
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.cacheDirectory = caches.appendingPathComponent(cache, isDirectory: true)
        createCacheDirectoryIfNeeded()
    }

    private func createCacheDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    // Public API: fetch image by path component (e.g., "/apps/dota2/.../image.png").
    // This will deliver the image via the provided closure in multiple stages:
    // first from memory cache (if available),
    // then from disk cache (if available),
    // and finally from the network.
    // The deliver closure is always called on the main actor.
    @MainActor
    public func fetchImage(name: String, deliver: @escaping (UIImage) -> Void) async {
        let key = name

        // 1) Check memory cache
        if let image = memoryCache[key] {
            deliver(image)
            return
        }

        // 2) Check disk cache
        if let localImage = loadFromDisk(forKey: key) {
            deliver(localImage)
        }

        // 3) Deduplicate network fetches
        if let existing = await inFlight.task(for: key) {
            do {
                let networkImage = try await existing.value
                deliver(networkImage)
                return
            } catch {
                return
            }
        }

        // 4) Create a new network fetch task and register it
        let task = Task<UIImage, Error> { [baseURL] in
            defer { Task { await self.inFlight.removeTask(for: key) } }
            let url = baseURL.appendingPathComponent("\(name)\(imagePostFix).png")
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            saveToDisk(data: data, forKey: key)
            return image
        }

        await inFlight.set(task: task, for: key)

        do {
            let networkImage = try await task.value
            memoryCache[key] = networkImage
            deliver(networkImage)
        } catch {
            // Ignore or handle error as needed
        }
    }

    private func loadFromDisk(forKey key: String) -> UIImage? {
        let url = cacheDirectory.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    private func saveToDisk(data: Data, forKey key: String) {
        let url = cacheDirectory.appendingPathComponent(key)
        do {
            try data.write(to: url, options: [.atomic])
        } catch {
            // Best-effort cache; ignore errors
        }
    }
    
    func resetMemoryCache() {
        memoryCache = [:]
    }
}

private extension Data {
    var sha256Hex: String {
        let digest = SHA256.hash(data: self)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
