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
    func players(id: Int) async throws -> [String: Any]
    func playerWinLoss(id: Int) async throws -> (win: Int, loss: Int)
    func playerRecentMatches(id: Int) async throws -> [[String: Any]]
    func playersMatches(id: Int, limit: Int?, offset: Int?, win: Bool?, patch: Int?,
                        mode: Int?, lobby: Int?, region: Int?, date: Double?, laneRole: Int?,
                        heroID: Int?, isRadiant: Bool?, includedAccountID: [Int]?,
                        excludedAccountID: [Int]?, withHeroID: [Int]?, againstHeroID: [Int]?,
                        significant: Bool?, having: Int?, ascending: Bool, project: [String]?) async throws -> [[String: Any]]
    func constants<T>(service: OpenDotaConstantService, as type: T.Type) async throws -> T
}

extension OpenDotaFetching {
    func playersMatches(id: Int, limit: Int? = nil, offset: Int? = nil, win: Bool? = nil, patch: Int? = nil,
                        mode: Int? = nil, lobby: Int? = nil, region: Int? = nil, date: Double? = nil, laneRole: Int? = nil,
                        heroID: Int? = nil, isRadiant: Bool? = nil, includedAccountID: [Int]? = nil,
                        excludedAccountID: [Int]? = nil, withHeroID: [Int]? = nil, againstHeroID: [Int]? = nil,
                        significant: Bool? = nil, having: Int? = nil, ascending: Bool = true, project: [String]? = nil) async throws -> [[String: Any]] {
        try await playersMatches(id: id, limit: limit, offset: offset, win: win, patch: patch, mode: mode, lobby: lobby, region: region, date: date, laneRole: laneRole, heroID: heroID, isRadiant: isRadiant, includedAccountID: includedAccountID, excludedAccountID: excludedAccountID, withHeroID: withHeroID, againstHeroID: againstHeroID, significant: significant, having: having, ascending: ascending, project: project)
    }
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
                        mode: Int?, lobby: Int?, region: Int?, date: Double?, laneRole: Int?,
                        heroID: Int?, isRadiant: Bool?, includedAccountID: [Int]?,
                        excludedAccountID: [Int]?, withHeroID: [Int]?, againstHeroID: [Int]?,
                        significant: Bool?, having: Int?, ascending: Bool, project: [String]?) async throws -> [[String: Any]] {
        let url = "\(baseURL)/players/\(id)/matches"
        
        var query: [String: Any] = [:]
        setValueIfExist(dictionary: &query, key: "limit", value: limit)
        setValueIfExist(dictionary: &query, key: "offset", value: offset)
        setValueIfExist(dictionary: &query, key: "win", value: win as? NSNumber)
        setValueIfExist(dictionary: &query, key: "patch", value: patch)
        setValueIfExist(dictionary: &query, key: "game_mode", value: mode)
        setValueIfExist(dictionary: &query, key: "lobby_type", value: lobby)
        setValueIfExist(dictionary: &query, key: "region", value: region)
        setValueIfExist(dictionary: &query, key: "date", value: date)
        setValueIfExist(dictionary: &query, key: "lane_role", value: laneRole)
        setValueIfExist(dictionary: &query, key: "hero_id", value: heroID)
        setValueIfExist(dictionary: &query, key: "is_radiant", value: isRadiant as? NSNumber)
        setValueIfExist(dictionary: &query, key: "included_account_id", value: includedAccountID)
        setValueIfExist(dictionary: &query, key: "excluded_account_id", value: excludedAccountID)
        setValueIfExist(dictionary: &query, key: "with_hero_id", value: withHeroID)
        setValueIfExist(dictionary: &query, key: "against_hero_id", value: againstHeroID)
        setValueIfExist(dictionary: &query, key: "significant", value: significant as? NSNumber)
        setValueIfExist(dictionary: &query, key: "having", value: having)
        let sort = ascending ? "asc" : "desc"
        setValueIfExist(dictionary: &query, key: "sort", value: sort)
        setValueIfExist(dictionary: &query, key: "project", value: project)
        return try await network.json(urlString: url, as: [[String: Any]].self, query: query)
    }
    
    func constants<T>(service: OpenDotaConstantService, as type: T.Type) async throws -> T {
        let url = "\(baseURL)/constants/\(service.rawValue)"
        return try await network.json(urlString: url, as: type)
    }
    
    private func setValueIfExist(dictionary: inout [String: Any], key: String, value: Any?) {
        guard let value else {
            return
        }
        dictionary[key] = value
    }
}
