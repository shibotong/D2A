//
//  OpenDotaFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 8/12/2025.
//

import Foundation

enum OpenDotaConstantService: String {
    case abilities
    case abilityIDs = "ability_ids"
    case aghsDescription = "aghs_desc"
    case ancients
    case chatWheel = "chat_wheel"
    case cluster
    case countries
    case gameModes = "game_mode"
    case heroAbilities = "hero_abilities"
    case heroLore = "hero_lore"
    case heroes
    case itemColors = "item_colors"
    case itemIDs = "item_ids"
    case items
    case lobbyType = "lobby_type"
    case neutralAbilities = "neutral_abilities"
    case orderTypes = "order_types"
    case patch
    case patchnotes
    case permanentBuffs = "permanent_buffs"
    case playerColors = "player_colors"
    case region
    case skillshots
    case xpLevel = "xp_level"
}

protocol OpenDotaFetching {
    func matches(id: Int) async throws -> [String: Any]
    func constants<T>(service: OpenDotaConstantService, as type: T.Type) async throws -> T
}

struct OpenDotaFetcher: OpenDotaFetching {
    
    private let network: NetworkProviding
    
    private let baseURL = "https://api.opendota.com/api"
    
    init(network: NetworkProviding = NetworkProvider.shared) {
        self.network = network
    }
    
    /// Match data
    func matches(id: Int) async throws -> [String: Any] {
        let url = "\(baseURL)/matches/\(id)"
        return try await network.json(urlString: url, as: [String: Any].self)
    }
    
    /// Player data
    func players(id: Int) async throws -> [String: Any] {
        let url = "\(baseURL)/players/\(id)"
        return try await network.json(urlString: url, as: [String: Any].self)
    }
    
    /// Player win loss
    func playerWinLoss(id: Int) async throws -> (win: Int, loss: Int) {
        let url = "\(baseURL)/players/\(id)/wl"
        let data = try await network.json(urlString: url, as: [String: Any].self)
        let win = data["win"] as? Int ?? 0
        let loss = data["loss"] as? Int ?? 0
        return (win, loss)
    }
    
    /// Recent matches played (limited number of results)
    func playerRecentMatches(id: Int) async throws -> [[String: Any]] {
        let url = "\(baseURL)/players/\(id)/recentMatches"
        return try await network.json(urlString: url, as: [[String: Any]].self)
    }
    
    /// Matches played (full history, and supports column selection)
    func playersMatches(id: Int, limit: Int?, offset: Int?, win: Bool?, patch: Int?,
                        mode: Int?, lobby: Int?, region: Int?, date: Int?, laneRole: Int?,
                        heroID: Int?, isRadiant: Bool?, includedAccountID: [Int]?,
                        excludedAccountID: [Int]?, withHeroID: [Int]?, againstHeroID: [Int]?,
                        significant: Bool?, having: Int?, ascending: Bool = true, project: [String]?) async throws -> [[String: Any]] {
        let url = "\(baseURL)/players/\(id)/matches"
        return try await network.json(urlString: url, as: [[String: Any]].self)
    }
    
    func constants<T>(service: OpenDotaConstantService, as type: T.Type) async throws -> T {
        let url = "\(baseURL)/constants/\(service.rawValue)"
        return try await network.json(urlString: url, as: type)
    }
}
