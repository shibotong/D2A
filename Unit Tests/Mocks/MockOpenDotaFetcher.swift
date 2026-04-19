//
//  MockOpenDotaFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 19/4/2026.
//

@testable import D2A
import Foundation

struct MockOpenDotaFetcher: OpenDotaFetching {
    func constants(service: D2A.OpenDotaConstantService) async throws -> Any {
        switch service {
        case .abilities:
            return try JSONSerialization.jsonObject(with: abilities)
        case .abilityIDs:
            return abilityIDs
        case .heroes:
            return try JSONSerialization.jsonObject(with: heroes)
        case .heroAbilities:
            return try JSONSerialization.jsonObject(with: heroAbilities)
        default:
            return "service not provided"
        }
    }
    
    // MARK: abilities
    
    private let abilityIDs: [String: String] = [
        "665": "special_bonus_unique_antimage_6",
        "735": "special_bonus_unique_antimage_8",
        "966": "special_bonus_unique_antimage_manavoid_aoe",
        "1447": "antimage_persectur",
        "1495": "special_bonus_hp_regen_3",
        "5003": "antimage_mana_break",
        "5004": "antimage_blink",
        "5006": "antimage_mana_void",
        "6012": "special_bonus_unique_antimage",
        "6353": "special_bonus_unique_antimage_2",
        "6606": "special_bonus_unique_antimage_3",
        "6800": "special_bonus_unique_antimage_5",
        "7314": "antimage_counterspell",
    ]
    
    private let abilities = """
{
  "special_bonus_unique_antimage": {
    "dname": "-{s:bonus_AbilityCooldown}s Blink Cooldown"
  },
  "special_bonus_unique_antimage_2": {
    "dname": "-{s:bonus_AbilityCooldown}s Mana Void Cooldown"
  },
  "special_bonus_unique_antimage_3": {
    "dname": "+{s:bonus_AbilityCastRange} Blink Cast Range"
  },
  "special_bonus_unique_antimage_4": {
    "dname": "+{s:bonus_magic_resistance}% Counterspell Magic Resistance"
  },
  "special_bonus_unique_antimage_5": {
    "dname": "+{s:bonus_move_slow_min}%/{s:bonus_move_slow_max}% Persecutor Min/Max Movement Slow"
  },
  "special_bonus_unique_antimage_6": {
    "dname": "+{s:bonus_mana_void_damage_per_mana} Mana Void Damage Multiplier"
  },
  "special_bonus_unique_antimage_7": {
    "dname": "+{s:bonus_mana_per_hit_pct}% Max Mana Mana Burn"
  },
  "special_bonus_unique_antimage_8": {
    "dname": "+{s:bonus_mana_void_ministun}s Mana Void Stun"
  },
  "special_bonus_unique_antimage_manavoid_aoe": {
    "dname": "+{s:bonus_mana_void_aoe_radius} Mana Void Radius"
  },
  "special_bonus_hp_regen_3": {
    "dname": "+3 Health Regen"
  },
  "antimage_counterspell": {
    "dname": "Counterspell",
    "behavior": [
      "No Target",
      "Instant Cast"
    ],
    "dispellable": "Yes",
    "desc": "Passively grants magic resistance. Counterspell may be activated to create an anti-magic shell around Anti-Mage that blocks and reflects any targeted spells.",
    "attrib": [
      {
        "key": "magic_resistance",
        "header": "MAGIC RESISTANCE:",
        "value": [
          "14",
          "21",
          "28",
          "35"
        ]
      },
      {
        "key": "duration",
        "header": "DURATION:",
        "value": "1.3"
      },
      {
        "key": "duration_illusion",
        "header": "DURATION ILLUSION:",
        "value": "4",
        "generated": true
      },
      {
        "key": "outgoing_damage",
        "header": "OUTGOING DAMAGE:",
        "value": "0",
        "generated": true
      },
      {
        "key": "incoming_damage",
        "header": "INCOMING DAMAGE:",
        "value": "100",
        "generated": true
      },
      {
        "key": "does_reflect",
        "header": "DOES REFLECT:",
        "value": "1",
        "generated": true
      },
      {
        "key": "reflected_spell_amp",
        "header": "REFLECTED SPELL AMP:",
        "value": "0"
      },
      {
        "key": "heal_pct",
        "header": "HEAL PCT:",
        "value": "0",
        "generated": true
      },
      {
        "key": "abilitycastrange",
        "header": "CAST RANGE:",
        "value": "0",
        "generated": true
      },
      {
        "key": "abilitycastpoint",
        "header": "CAST TIME:",
        "value": "0",
        "generated": true
      }
    ],
    "lore": "With the proper focus, Anti-Mage turns innate resistance into calculated retaliation.",
    "mc": "50",
    "cd": [
      "15",
      "11",
      "7",
      "3"
    ],
    "img": "/apps/dota2/images/dota_react/abilities/antimage_counterspell.png"
  },
  "antimage_persectur": {
    "dname": "Persecutor",
    "is_innate": true,
    "behavior": "Passive",
    "bkbpierce": "No",
    "desc": "Attacks slow enemies based on how much mana they are missing. Min slow at 50% mana, up to max slow at 0% mana. No effect if enemy is above 50% mana.",
    "attrib": [
      {
        "key": "move_slow_min",
        "header": "MIN MOVEMENT SLOW:",
        "value": "12%"
      },
      {
        "key": "move_slow_max",
        "header": "MAX MOVEMENT SLOW:",
        "value": "24%"
      },
      {
        "key": "mana_threshold",
        "header": "MANA THRESHOLD:",
        "value": "50",
        "generated": true
      },
      {
        "key": "slow_duration",
        "header": "SLOW DURATION:",
        "value": "0.75"
      },
      {
        "key": "zero_tooltip",
        "header": "ZERO TOOLTIP:",
        "value": "0",
        "generated": true
      }
    ],
    "img": "/apps/dota2/images/dota_react/abilities/antimage_persectur.png"
  },
  "antimage_mana_break": {
    "dname": "Mana Break",
    "behavior": "Passive",
    "dmg_type": "Physical",
    "bkbpierce": "No",
    "desc": "Burns an opponent's mana on each attack and deals damage equal to a percentage of the mana burnt.",
    "attrib": [
      {
        "key": "percent_damage_per_burn",
        "header": "MANA BURNED AS DAMAGE:",
        "value": "50"
      },
      {
        "key": "mana_per_hit",
        "header": "MANA BURNED PER HIT:",
        "value": [
          "25",
          "30",
          "35",
          "40"
        ]
      },
      {
        "key": "mana_per_hit_pct",
        "header": "MAX MANA BURNED PER HIT:",
        "value": [
          "1.6",
          "2.4",
          "3.2",
          "4"
        ]
      },
      {
        "key": "illusion_percentage",
        "header": "ILLUSION PERCENTAGE:",
        "value": "25",
        "generated": true
      },
      {
        "key": "empowered_max_burn_pct",
        "header": "EMPOWERED MAX BURN PCT:",
        "value": "0",
        "generated": true
      },
      {
        "key": "empowered_mana_break_debuff_duration",
        "header": "EMPOWERED MANA BREAK DEBUFF DURATION:",
        "value": "0",
        "generated": true
      }
    ],
    "lore": "A modified technique of the Turstarkuri monks' peaceful ways is to turn magical energies on their owner.",
    "img": "/apps/dota2/images/dota_react/abilities/antimage_mana_break.png"
  },
  "antimage_blink": {
    "dname": "Blink",
    "behavior": "Point Target",
    "desc": "Short distance teleportation that allows Anti-Mage to move in and out of combat.",
    "attrib": [
      {
        "key": "abilitycastrange",
        "header": "CAST RANGE:",
        "value": [
          "875",
          "950",
          "1025",
          "1100"
        ],
        "generated": true
      },
      {
        "key": "min_blink_range",
        "header": "MIN BLINK RANGE:",
        "value": "200",
        "generated": true
      },
      {
        "key": "empowered_mana_break_duration",
        "header": "EMPOWERED MANA BREAK DURATION:",
        "value": "0",
        "generated": true
      },
      {
        "key": "empowered_max_burn_pct_tooltip",
        "header": "EMPOWERED MAX BURN PCT TOOLTIP:",
        "value": "0",
        "generated": true
      },
      {
        "key": "empowered_mana_break_debuff_duration_tooltip",
        "header": "DEBUFF DURATION:",
        "value": "0"
      },
      {
        "key": "abilitycastpoint",
        "header": "CAST TIME:",
        "value": "0.4",
        "generated": true
      }
    ],
    "lore": "In his encounter with the Dead Gods, Anti-Mage learned the value of being elusive.",
    "mc": [
      "65",
      "60",
      "55",
      "50"
    ],
    "cd": [
      "10.5",
      "9",
      "7.5",
      "6"
    ],
    "img": "/apps/dota2/images/dota_react/abilities/antimage_blink.png"
  },
  "antimage_mana_void": {
    "dname": "Mana Void",
    "behavior": [
      "Unit Target",
      "AOE"
    ],
    "dmg_type": "Magical",
    "bkbpierce": "No",
    "target_team": "Enemy",
    "target_type": [
      "Hero",
      "Basic"
    ],
    "desc": "For each point of mana missing by the target unit, damage is dealt to it and surrounding enemies. The main target is also mini-stunned.",
    "attrib": [
      {
        "key": "mana_void_damage_per_mana",
        "header": "DAMAGE PER 1 MANA MISSING:",
        "value": "1"
      },
      {
        "key": "mana_void_ministun",
        "header": "STUN DURATION:",
        "value": "0.3"
      },
      {
        "key": "mana_void_aoe_radius",
        "header": "RADIUS:",
        "value": [
          "400",
          "450",
          "500"
        ]
      },
      {
        "key": "thirst_enabled",
        "header": "THIRST ENABLED:",
        "value": "0",
        "generated": true
      },
      {
        "key": "thirst_range",
        "header": "THIRST RANGE:",
        "value": "0",
        "generated": true
      },
      {
        "key": "threshold_pct",
        "header": "THRESHOLD PCT:",
        "value": "0",
        "generated": true
      },
      {
        "key": "min_bonus_pct",
        "header": "MIN BONUS PCT:",
        "value": "0",
        "generated": true
      },
      {
        "key": "max_bonus_pct",
        "header": "MAX BONUS PCT:",
        "value": "0",
        "generated": true
      },
      {
        "key": "bonus_attack_damage",
        "header": "MANA THIRST MAX ATTACK DAMAGE:",
        "value": "0"
      },
      {
        "key": "linger_duration",
        "header": "LINGER DURATION:",
        "value": "0",
        "generated": true
      },
      {
        "key": "abilitycastrange",
        "header": "CAST RANGE:",
        "value": "600",
        "generated": true
      },
      {
        "key": "abilitycastpoint",
        "header": "CAST TIME:",
        "value": "0.3",
        "generated": true
      }
    ],
    "lore": "After bringing enemies to their knees, Anti-Mage punishes them for their use of the arcane arts.",
    "mc": [
      "100",
      "150",
      "200"
    ],
    "cd": [
      "100",
      "85",
      "70"
    ],
    "img": "/apps/dota2/images/dota_react/abilities/antimage_mana_void.png"
  }
}
""".data(using: .utf8)!
    
    // MARK: heroes
    
    private let heroes = """
        {
          "1": {
            "id": 1,
            "name": "npc_dota_hero_antimage",
            "primary_attr": "agi",
            "attack_type": "Melee",
            "roles": [
              "Carry",
              "Escape",
              "Nuker"
            ],
            "img": "/apps/dota2/images/dota_react/heroes/antimage.png?",
            "icon": "/apps/dota2/images/dota_react/heroes/icons/antimage.png?",
            "base_health": 120,
            "base_health_regen": 1,
            "base_mana": 75,
            "base_mana_regen": 0,
            "base_armor": 2,
            "base_mr": 25,
            "base_attack_min": 29,
            "base_attack_max": 33,
            "base_str": 21,
            "base_agi": 24,
            "base_int": 12,
            "str_gain": 1.6,
            "agi_gain": 2.8,
            "int_gain": 1.8,
            "attack_range": 150,
            "projectile_speed": 0,
            "attack_rate": 1.4,
            "base_attack_time": 100,
            "attack_point": 0.3,
            "move_speed": 310,
            "turn_rate": null,
            "cm_enabled": true,
            "legs": 2,
            "day_vision": 1800,
            "night_vision": 800,
            "localized_name": "Anti-Mage"
          }
        }
        """.data(using: .utf8)!
    
    private let heroAbilities = """
        {
          "npc_dota_hero_antimage": {
            "abilities": [
              "antimage_mana_break",
              "antimage_blink",
              "antimage_counterspell",
              "generic_hidden",
              "antimage_persectur",
              "antimage_mana_void"
            ],
            "talents": [
              {
                "name": "special_bonus_hp_regen_3",
                "level": 1
              },
              {
                "name": "special_bonus_unique_antimage_manavoid_aoe",
                "level": 1
              },
              {
                "name": "special_bonus_unique_antimage_5",
                "level": 2
              },
              {
                "name": "special_bonus_unique_antimage_6",
                "level": 2
              },
              {
                "name": "special_bonus_unique_antimage_3",
                "level": 3
              },
              {
                "name": "special_bonus_unique_antimage_8",
                "level": 3
              },
              {
                "name": "special_bonus_unique_antimage",
                "level": 4
              },
              {
                "name": "special_bonus_unique_antimage_2",
                "level": 4
              }
            ],
            "facets": [
              {
                "id": 0,
                "name": "antimage_magebanes_mirror",
                "deprecated": "true",
                "icon": "ricochet",
                "color": "Purple",
                "gradient_id": 1,
                "title": "Magebane's Mirror",
                "description": "Spells countered by Counterspell will immediately burn a percentage of its mana cost from the enemy and deal damage based on the burned mana cost."
              },
              {
                "id": 1,
                "name": "antimage_mana_thirst",
                "deprecated": "true",
                "icon": "mana",
                "color": "Blue",
                "gradient_id": 3,
                "title": "Mana Thirst",
                "description": "Anti-Mage gains damage when his enemies are at low mana."
              }
            ]
          }
        }
        """.data(using: .utf8)!
}
