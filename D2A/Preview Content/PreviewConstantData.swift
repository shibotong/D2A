//
//  PreviewConstantData.swift
//  D2A
//
//  Created by Shibo Tong on 20/4/2026.
//

import Foundation
import Stratz

struct PreviewConstantData {
    
    static let abilityIDs: [String: String] = {
        let data = try! readFile("ability_ids")
        return try! JSONSerialization.jsonObject(with: data) as! [String: String]
    }()
    
    static let abilities: [String: Any] = {
        let data = try! readFile("abilities")
        return try! JSONSerialization.jsonObject(with: data) as! [String: Any]
    }()
    
    static let abilityTranslation: [SKAbility] = [
        .init(id: 5003,
              name: "antimage_mana_break",
              displayName: "Mana Break",
              lore: "A modified technique of the Turstarkuri monks' peaceful ways is to turn magical energies on their owner.",
              description: ["Burns an opponent's mana on each attack and deals damage equal to a percentage of the mana burnt."],
              attributes: [
                "MANA BURNED PER HIT: 25 / 30 / 35 / 40",
                "MAX MANA BURNED PER HIT: 1.6% / 2.4% / 3.2% / 4%",
                "MANA BURNED AS DAMAGE: 50%"
              ],
              aghanimDescription: nil,
              shardDescription: nil),
        .init(id: 5004,
              name: "antimage_blink",
              displayName: "Blink",
              lore: "In his encounter with the Dead Gods, Anti-Mage learned the value of being elusive.",
              description: ["Short distance teleportation that allows Anti-Mage to move in and out of combat."],
              attributes: ["DEBUFF DURATION: 0"],
              aghanimDescription: "After casting Blink, your next Mana Break within 0s burns an additional 0.0 max mana and prevents the target from regenerating or gaining mana for a short duration. This debuff is undispellable. Blink Cooldown reduced by %bonus_AbilityCooldown%s.",
              shardDescription: nil),
        .init(id: 7314,
              name: "antimage_counterspell",
              displayName: "Counterspell",
              lore: "With the proper focus, Anti-Mage turns innate resistance into calculated retaliation.",
              description: [
                "Passively grants magic resistance. Counterspell may be activated to create an anti-magic shell around Anti-Mage that blocks and reflects any targeted spells."
              ],
              attributes: [
                "%REFLECTED SPELL AMP:%ally_reflected_spell_amp%",
                "%MANA BURN PERCENTAGE:%ally_mana_drain_percent%",
                "MAGIC RESISTANCE: 16% / 24% / 32% / 40%",
                "DURATION: 1.2",
                "REFLECTED SPELL AMP: 0%",
                "MANA BURN PERCENTAGE: %"
              ],
              aghanimDescription: nil,
              shardDescription: "Creates a blinked fragment of Anti-Mage next to the enemy caster upon reflecting their unit-targeted spell while active."),
        .init(id: 1447,
              name: "antimage_persectur",
              displayName: "Persecutor",
              lore: nil,
              description: ["Attacks slow enemies based on how much mana they are missing. Min slow at 50% mana, up to max slow at 0% mana. No effect if enemy is above 50% mana."],
              attributes: [
                "MIN MOVEMENT SLOW: 12.5% / 15.0% / 17.5% / 20%",
                "MAX MOVEMENT SLOW: 25% / 30% / 35% / 40%",
                "SLOW DURATION: 0.75"
              ],
              aghanimDescription: nil,
              shardDescription: nil),
        .init(id: 5006,
              name: "antimage_mana_void",
              displayName: "Mana Void",
              lore: "After bringing enemies to their knees, Anti-Mage punishes them for their use of the arcane arts.",
              description: ["For each point of mana missing by the target unit, damage is dealt to it and surrounding enemies.  The main target is also mini-stunned."],
              attributes: [
                "DAMAGE: 0.8 / 0.95 / 1.1",
                "STUN DURATION: 0.3",
                "RADIUS: 500",
                "MANA THIRST MAX ATTACK DAMAGE: "
              ],
              aghanimDescription: nil,
              shardDescription: nil),
        .init(id: 966,
              name: "special_bonus_unique_antimage_manavoid_aoe",
              displayName: "+200 Mana Void Radius"),
        .init(id: 1495,
              name: "special_bonus_hp_regen_3",
              displayName: "+3 Health Regen"),
        .init(id: 665,
              name: "special_bonus_unique_antimage_6",
              displayName: "+0.2 Mana Void Damage Multiplier"),
        .init(id: 6800,
              name: "special_bonus_unique_antimage_5",
              displayName: "+9%/18% Persecutor Min/Max Movement Slow"),
        .init(id: 735,
              name: "special_bonus_unique_antimage_8",
              displayName: "+0.8s Mana Void Stun"),
        .init(id: 6606,
              name: "special_bonus_unique_antimage_3",
              displayName: "+200 Blink Cast Range"),
        .init(id: 6353,
              name: "special_bonus_unique_antimage_2",
              displayName: "-50s Mana Void Cooldown"),
        .init(id: 6012,
              name: "special_bonus_unique_antimage",
              displayName: "-{s:bonus_AbilityCooldown}s Blink Cooldown"),
    ]
    
    // MARK: heroes
    
    static let heroes: [String: Any] = {
        let data = try! readFile("heroes")
        return try! JSONSerialization.jsonObject(with: data) as! [String: Any]
    }()
    
    static let heroAbilities: [String: Any] = {
        let data = try! readFile("hero_abilities")
        return try! JSONSerialization.jsonObject(with: data) as! [String: Any]
    }()
    
    static let heroAdditionalData = [SKHeroAdditional(heroID: 1,
                                                      name: "npc_dota_hero_antimage", complexity: 1, roles: [
                                                        .init(level: 3, roleId: "CARRY"),
                                                        .init(level: 3, roleId: "ESCAPE"),
                                                        .init(level: 1, roleId: "NUKER")
                                                      ])]
    
    static let heroTranslation: [SKHero] = {
        let hero = SKHero(id: 1, roles: [
            .init(level: 3, roleId: "CARRY"),
            .init(level: 3, roleId: "ESCAPE"),
            .init(level: 1, roleId: "NUKER")
        ], displayName: "Anti-Mage", lore: "The monks of Turstarkuri watched the rugged valleys below their mountain monastery as wave after wave of invaders swept through the lower kingdoms. Ascetic and pragmatic, in their remote monastic eyrie they remained aloof from mundane strife, wrapped in meditation that knew no gods or elements of magic. Then came the Legion of the Dead God, crusaders with a sinister mandate to replace all local worship with their Unliving Lord's poisonous nihilosophy. From a landscape that had known nothing but blood and battle for a thousand years, they tore the souls and bones of countless fallen legions and pitched them against Turstarkuri. The monastery stood scarcely a fortnight against the assault, and the few monks who bothered to surface from their meditations believed the invaders were but demonic visions sent to distract them from meditation. They died where they sat on their silken cushions. Only one youth survived--a pilgrim who had come as an acolyte, seeking wisdom, but had yet to be admitted to the monastery. He watched in horror as the monks to whom he had served tea and nettles were first slaughtered, then raised to join the ranks of the Dead God's priesthood. With nothing but a few of Turstarkuri's prized dogmatic scrolls, he crept away to the comparative safety of other lands, swearing to obliterate not only the Dead God's magic users--but to put an end to magic altogether. ", hype: "Should Anti-Mage have the opportunity to gather his full strength, few can stop his assaults. <b>Draining mana</b> from enemies with every strike or <b>teleporting short distances</b> to escape an ambush, cornering him is a challenge for any foe.")
        return [hero]
    }()
}
