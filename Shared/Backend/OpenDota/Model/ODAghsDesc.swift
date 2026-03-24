//
//  ODAghsDesc.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

struct ODAghsDesc: Decodable {
    let heroName: String
    let heroId: Int
    let hasScepter: Bool
    let scepterDesc: String
    let scepterSkillName: String
    let scepterNewSkill: Bool
    let hasShard: Bool
    let shardDesc: String
    let shardSkillName: String
    let shardNewSkill: Bool
}
