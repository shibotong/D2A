//
//  OpenDotaFetcher+ConstantService.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2026.
//

extension OpenDotaFetcher {
    public enum ConstantService: String {
        case abilities
        case abilityIDs = "ability_ids"
        case aghsDesc = "aghs_desc"
        case ancients
        case chatWheel = "chat_wheel"
        case cluster
        case countries
        case gameMode = "game_mode"
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
}
