#!/usr/bin/env swift
print("Running Create Release")

import Foundation

guard CommandLine.arguments.count == 5 else {
    print(
    """
    Error: Please provide Git auth token
    Usage: create_release.swift <username> <repo> <git_token> <app_version>
    """
    )
    exit(1)
}

struct Release: Decodable {
    let tagName: String
    let createdAt: Date
}

struct GenerateNote: Decodable {
    let body: String
}

enum ScriptError: Error {
    case noLatestRelease
    case noHttpResponse
    case createRelease
    case statusCode(Int)
}

func createRequest(_ url: URL, method: String) -> URLRequest {
    var request = URLRequest(url: url)
    request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    request.setValue("2026-03-10", forHTTPHeaderField: "X-GitHub-Api-Version")
    request.httpMethod = method
    return request
}

let username = CommandLine.arguments[1]
let repo = CommandLine.arguments[2]
let authToken = CommandLine.arguments[3]
let version = CommandLine.arguments[4]

let releasesURL = URL(string: "https://api.github.com/repos/\(username)/\(repo)/releases")!
let releaseNoteURL = URL(string: "https://api.github.com/repos/\(username)/\(repo)/releases/generate-notes")!

let fetchReleases = createRequest(releasesURL, method: "GET")
var generateNotes = createRequest(releaseNoteURL, method: "POST")
var createReleases = createRequest(releasesURL, method: "POST")

let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
decoder.dateDecodingStrategy = .iso8601

// fetch latest release
print("Fetching latest tag...")
let latestTagName: String
do {
    let (data, _) = try await URLSession.shared.data(for: fetchReleases)
    let releases = try decoder.decode([Release].self, from: data)
    guard let latestRelease = releases.sorted(by: { $0.createdAt < $1.createdAt }).last else {
        throw ScriptError.noLatestRelease
    }
    latestTagName = latestRelease.tagName
} catch {
    print("Error: Fetch latest release \(error)")
    exit(1)
}

// generate notes
print("Generating Notes...")
let note: String
do {
    let generateNoteBody = ["tag_name": version, "target_commitish": "main", "previous_tag_name": latestTagName]
    let body = try JSONSerialization.data(withJSONObject: generateNoteBody)
    generateNotes.httpBody = body
    let (data, _) = try await URLSession.shared.data(for: generateNotes)
    let generateNote = try decoder.decode(GenerateNote.self, from: data)
    note = generateNote.body
} catch {
    print("Error: Generate release note \(error)")
    exit(1)
}

// create release
print("Creating Release...")
do {
    let createReleaseBody = ["tag_name": version, "target_commitish": "main", "name": version, "body": note, "make_latest": "true"]
    let body = try JSONSerialization.data(withJSONObject: createReleaseBody)
    createReleases.httpBody = body
    let (_, response) = try await URLSession.shared.data(for: createReleases)
    if let httpResponse = response as? HTTPURLResponse {
        let statusCode = httpResponse.statusCode
        if statusCode >= 200 && statusCode <= 299 {
            print("Create release success!")
        } else {
            throw ScriptError.statusCode(statusCode)
        }
    } else {
        throw ScriptError.noHttpResponse
    }
} catch {
    print("Error: Create release \(error)")
    exit(1)
}
