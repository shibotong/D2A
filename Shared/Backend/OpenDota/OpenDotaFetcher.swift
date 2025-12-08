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
    func constants<T>(service: OpenDotaConstantService, as type: T.Type) async throws -> T
}

struct OpenDotaFetcher: OpenDotaFetching {
    
    private let network: NetworkProviding
    
    private let baseURL = "https://api.opendota.com/api"
    
    init(network: NetworkProviding = NetworkProvider.shared) {
        self.network = network
    }
    
    func constants<T>(service: OpenDotaConstantService, as type: T.Type) async throws -> T {
        let url = "\(baseURL)/constants/\(service.rawValue)"
        return try await network.json(urlString: url, as: type)
    }
}
