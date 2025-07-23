//
//  ODScepter.swift
//  D2A
//
//  Created by Shibo Tong on 22/7/2025.
//

struct ODScepter: Decodable {
    var name: String
    var id: Int
    var scepterDesc: String
    var scepterSkillName: String
    var scepterNewSkill: Bool
    var shardDesc: String
    var shardSkillName: String
    var shardNewSkill: Bool

    enum CodingKeys: String, CodingKey {
        case name = "hero_name"
        case id = "hero_id"
        case scepterDesc = "scepter_desc"
        case scepterSkillName = "scepter_skill_name"
        case scepterNewSkill = "scepter_new_skill"
        case shardDesc = "shard_desc"
        case shardSkillName = "shard_skill_name"
        case shardNewSkill = "shard_new_skill"
    }
}
