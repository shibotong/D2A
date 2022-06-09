////
////  ReadDataWidget.swift
////  App
////
////  Created by Shibo Tong on 18/9/21.
////
//
//import Foundation
//
//fileprivate func loadFile(filename: String) -> Data? {
//    if let path = Bundle.main.url(forResource: filename, withExtension: "json") {
//        do {
//            let data = try Data(contentsOf: path)
//            return data
//        } catch {
//            print("No such file")
//            return nil
//        }
//    } else {
//        return nil
//    }
//}
//
//func loadRecentMatches() -> [RecentMatch]? {
//    guard let data = loadFile(filename: "sampleRecentMatch") else {
//        return nil
//    }
//    do {
//        let decoder = JSONDecoder()
//        let jsonData = try decoder.decode([RecentMatch].self, from: data)
//        return jsonData
//    } catch {
//        // handle error
//        print("Cannot parse json data")
//        return nil
//    }
//
//}
//
//func loadMatch() -> Match? {
//    guard let data = loadFile(filename: "sampleMatch") else {
//        return nil
//    }
//
//    do {
//        let decoder = JSONDecoder()
//        let jsonData = try decoder.decode(Match.self, from: data)
//        return jsonData
//    } catch {
//        print("Cannot parse json data")
//        return nil
//    }
//
//}
//
//func loadLobby() -> [String: LobbyType]? {
//    guard let data = loadFile(filename: "lobby_type") else {
//        return nil
//    }
//    do {
//        let decoder = JSONDecoder()
//        let jsonData = try decoder.decode([String: LobbyType].self, from: data)
//        return jsonData
//    } catch {
//        print("Cannot parse Lobby data")
//        return nil
//    }
//}
//
//func loadGameModes() -> [String: GameMode]? {
//    guard let data = loadFile(filename: "game_mode") else {
//        fatalError("no game mode file")
//    }
//    do {
//        let decoder = JSONDecoder()
//        let modes = try decoder.decode([String: GameMode].self, from: data)
//        return modes
//    } catch {
//        print("cannot parse mode file")
//        return nil
//    }
//}
//
//func loadHeroes() -> [String: Hero]? {
//    guard let data = loadFile(filename: "heroes") else {
//        return nil
//    }
//    do {
//        let decoder = JSONDecoder()
//        let jsonData = try decoder.decode([String: Hero].self, from: data)
//        return jsonData
//    } catch {
//        print("Cannot parse Lobby data")
//        return nil
//    }
//}
//
//func loadProfile() -> SteamProfile? {
//    guard let data = loadFile(filename: "sampleProfile") else {
//        return nil
//    }
//
//    do {
//
//        let decoder = JSONDecoder()
//        let jsonData = try decoder.decode(SteamProfile.self, from: data)
//        return jsonData
//    } catch {
//        // handle error
//        print("Cannot parse json data")
//        return nil
//    }
//}
