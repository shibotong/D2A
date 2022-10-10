// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum Language: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case english
  case brazilian
  case bulgarian
  case czech
  case danish
  case dutch
  case finnish
  case french
  case german
  case greek
  case hungarian
  case italian
  case japanese
  case korean
  case koreana
  case norwegian
  case polish
  case portuguese
  case romanian
  case russian
  case sChinese
  case spanish
  case swedish
  case tChinese
  case thai
  case turkish
  case ukrainian
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ENGLISH": self = .english
      case "BRAZILIAN": self = .brazilian
      case "BULGARIAN": self = .bulgarian
      case "CZECH": self = .czech
      case "DANISH": self = .danish
      case "DUTCH": self = .dutch
      case "FINNISH": self = .finnish
      case "FRENCH": self = .french
      case "GERMAN": self = .german
      case "GREEK": self = .greek
      case "HUNGARIAN": self = .hungarian
      case "ITALIAN": self = .italian
      case "JAPANESE": self = .japanese
      case "KOREAN": self = .korean
      case "KOREANA": self = .koreana
      case "NORWEGIAN": self = .norwegian
      case "POLISH": self = .polish
      case "PORTUGUESE": self = .portuguese
      case "ROMANIAN": self = .romanian
      case "RUSSIAN": self = .russian
      case "S_CHINESE": self = .sChinese
      case "SPANISH": self = .spanish
      case "SWEDISH": self = .swedish
      case "T_CHINESE": self = .tChinese
      case "THAI": self = .thai
      case "TURKISH": self = .turkish
      case "UKRAINIAN": self = .ukrainian
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .english: return "ENGLISH"
      case .brazilian: return "BRAZILIAN"
      case .bulgarian: return "BULGARIAN"
      case .czech: return "CZECH"
      case .danish: return "DANISH"
      case .dutch: return "DUTCH"
      case .finnish: return "FINNISH"
      case .french: return "FRENCH"
      case .german: return "GERMAN"
      case .greek: return "GREEK"
      case .hungarian: return "HUNGARIAN"
      case .italian: return "ITALIAN"
      case .japanese: return "JAPANESE"
      case .korean: return "KOREAN"
      case .koreana: return "KOREANA"
      case .norwegian: return "NORWEGIAN"
      case .polish: return "POLISH"
      case .portuguese: return "PORTUGUESE"
      case .romanian: return "ROMANIAN"
      case .russian: return "RUSSIAN"
      case .sChinese: return "S_CHINESE"
      case .spanish: return "SPANISH"
      case .swedish: return "SWEDISH"
      case .tChinese: return "T_CHINESE"
      case .thai: return "THAI"
      case .turkish: return "TURKISH"
      case .ukrainian: return "UKRAINIAN"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Language, rhs: Language) -> Bool {
    switch (lhs, rhs) {
      case (.english, .english): return true
      case (.brazilian, .brazilian): return true
      case (.bulgarian, .bulgarian): return true
      case (.czech, .czech): return true
      case (.danish, .danish): return true
      case (.dutch, .dutch): return true
      case (.finnish, .finnish): return true
      case (.french, .french): return true
      case (.german, .german): return true
      case (.greek, .greek): return true
      case (.hungarian, .hungarian): return true
      case (.italian, .italian): return true
      case (.japanese, .japanese): return true
      case (.korean, .korean): return true
      case (.koreana, .koreana): return true
      case (.norwegian, .norwegian): return true
      case (.polish, .polish): return true
      case (.portuguese, .portuguese): return true
      case (.romanian, .romanian): return true
      case (.russian, .russian): return true
      case (.sChinese, .sChinese): return true
      case (.spanish, .spanish): return true
      case (.swedish, .swedish): return true
      case (.tChinese, .tChinese): return true
      case (.thai, .thai): return true
      case (.turkish, .turkish): return true
      case (.ukrainian, .ukrainian): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Language] {
    return [
      .english,
      .brazilian,
      .bulgarian,
      .czech,
      .danish,
      .dutch,
      .finnish,
      .french,
      .german,
      .greek,
      .hungarian,
      .italian,
      .japanese,
      .korean,
      .koreana,
      .norwegian,
      .polish,
      .portuguese,
      .romanian,
      .russian,
      .sChinese,
      .spanish,
      .swedish,
      .tChinese,
      .thai,
      .turkish,
      .ukrainian,
    ]
  }
}

public enum HeroRoleEnum: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case carry
  case escape
  case nuker
  case initiator
  case durable
  case disabler
  case jungler
  case support
  case pusher
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CARRY": self = .carry
      case "ESCAPE": self = .escape
      case "NUKER": self = .nuker
      case "INITIATOR": self = .initiator
      case "DURABLE": self = .durable
      case "DISABLER": self = .disabler
      case "JUNGLER": self = .jungler
      case "SUPPORT": self = .support
      case "PUSHER": self = .pusher
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .carry: return "CARRY"
      case .escape: return "ESCAPE"
      case .nuker: return "NUKER"
      case .initiator: return "INITIATOR"
      case .durable: return "DURABLE"
      case .disabler: return "DISABLER"
      case .jungler: return "JUNGLER"
      case .support: return "SUPPORT"
      case .pusher: return "PUSHER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: HeroRoleEnum, rhs: HeroRoleEnum) -> Bool {
    switch (lhs, rhs) {
      case (.carry, .carry): return true
      case (.escape, .escape): return true
      case (.nuker, .nuker): return true
      case (.initiator, .initiator): return true
      case (.durable, .durable): return true
      case (.disabler, .disabler): return true
      case (.jungler, .jungler): return true
      case (.support, .support): return true
      case (.pusher, .pusher): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [HeroRoleEnum] {
    return [
      .carry,
      .escape,
      .nuker,
      .initiator,
      .durable,
      .disabler,
      .jungler,
      .support,
      .pusher,
    ]
  }
}

public final class AbilityQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Ability($language: Language) {
      constants {
        __typename
        abilities(language: $language) {
          __typename
          id
          name
          language {
            __typename
            displayName
            description
            attributes
            lore
            aghanimDescription
            shardDescription
            notes
          }
        }
      }
    }
    """

  public let operationName: String = "Ability"

  public var language: Language?

  public init(language: Language? = nil) {
    self.language = language
  }

  public var variables: GraphQLMap? {
    return ["language": language]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["DotaQuery"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("constants", type: .object(Constant.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(constants: Constant? = nil) {
      self.init(unsafeResultMap: ["__typename": "DotaQuery", "constants": constants.flatMap { (value: Constant) -> ResultMap in value.resultMap }])
    }

    /// Queries used to query constants in Dota.
    public var constants: Constant? {
      get {
        return (resultMap["constants"] as? ResultMap).flatMap { Constant(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "constants")
      }
    }

    public struct Constant: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ConstantQuery"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("abilities", arguments: ["language": GraphQLVariable("language")], type: .list(.object(Ability.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(abilities: [Ability?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "ConstantQuery", "abilities": abilities.flatMap { (value: [Ability?]) -> [ResultMap?] in value.map { (value: Ability?) -> ResultMap? in value.flatMap { (value: Ability) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Find ability details.
      public var abilities: [Ability?]? {
        get {
          return (resultMap["abilities"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Ability?] in value.map { (value: ResultMap?) -> Ability? in value.flatMap { (value: ResultMap) -> Ability in Ability(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Ability?]) -> [ResultMap?] in value.map { (value: Ability?) -> ResultMap? in value.flatMap { (value: Ability) -> ResultMap in value.resultMap } } }, forKey: "abilities")
        }
      }

      public struct Ability: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["AbilityType"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(Short.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("language", type: .object(Language.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Short? = nil, name: String? = nil, language: Language? = nil) {
          self.init(unsafeResultMap: ["__typename": "AbilityType", "id": id, "name": name, "language": language.flatMap { (value: Language) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: Short? {
          get {
            return resultMap["id"] as? Short
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var language: Language? {
          get {
            return (resultMap["language"] as? ResultMap).flatMap { Language(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "language")
          }
        }

        public struct Language: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["AbilityLanguageType"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("displayName", type: .scalar(String.self)),
              GraphQLField("description", type: .list(.scalar(String.self))),
              GraphQLField("attributes", type: .list(.scalar(String.self))),
              GraphQLField("lore", type: .scalar(String.self)),
              GraphQLField("aghanimDescription", type: .scalar(String.self)),
              GraphQLField("shardDescription", type: .scalar(String.self)),
              GraphQLField("notes", type: .list(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(displayName: String? = nil, description: [String?]? = nil, attributes: [String?]? = nil, lore: String? = nil, aghanimDescription: String? = nil, shardDescription: String? = nil, notes: [String?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "AbilityLanguageType", "displayName": displayName, "description": description, "attributes": attributes, "lore": lore, "aghanimDescription": aghanimDescription, "shardDescription": shardDescription, "notes": notes])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var displayName: String? {
            get {
              return resultMap["displayName"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "displayName")
            }
          }

          public var description: [String?]? {
            get {
              return resultMap["description"] as? [String?]
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }

          public var attributes: [String?]? {
            get {
              return resultMap["attributes"] as? [String?]
            }
            set {
              resultMap.updateValue(newValue, forKey: "attributes")
            }
          }

          public var lore: String? {
            get {
              return resultMap["lore"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "lore")
            }
          }

          public var aghanimDescription: String? {
            get {
              return resultMap["aghanimDescription"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "aghanimDescription")
            }
          }

          public var shardDescription: String? {
            get {
              return resultMap["shardDescription"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "shardDescription")
            }
          }

          public var notes: [String?]? {
            get {
              return resultMap["notes"] as? [String?]
            }
            set {
              resultMap.updateValue(newValue, forKey: "notes")
            }
          }
        }
      }
    }
  }
}

public final class HeroQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Hero($id: Short!) {
      constants {
        __typename
        hero(id: $id) {
          __typename
          id
          name
          displayName
          shortName
          aliases
          roles {
            __typename
            roleId
            level
          }
          talents {
            __typename
            abilityId
            slot
          }
          stats {
            __typename
            visionDaytimeRange
            visionNighttimeRange
            complexity
          }
        }
      }
    }
    """

  public let operationName: String = "Hero"

  public var id: Short

  public init(id: Short) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["DotaQuery"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("constants", type: .object(Constant.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(constants: Constant? = nil) {
      self.init(unsafeResultMap: ["__typename": "DotaQuery", "constants": constants.flatMap { (value: Constant) -> ResultMap in value.resultMap }])
    }

    /// Queries used to query constants in Dota.
    public var constants: Constant? {
      get {
        return (resultMap["constants"] as? ResultMap).flatMap { Constant(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "constants")
      }
    }

    public struct Constant: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ConstantQuery"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("hero", arguments: ["id": GraphQLVariable("id")], type: .object(Hero.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(hero: Hero? = nil) {
        self.init(unsafeResultMap: ["__typename": "ConstantQuery", "hero": hero.flatMap { (value: Hero) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var hero: Hero? {
        get {
          return (resultMap["hero"] as? ResultMap).flatMap { Hero(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "hero")
        }
      }

      public struct Hero: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["HeroType"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(Short.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("displayName", type: .scalar(String.self)),
            GraphQLField("shortName", type: .scalar(String.self)),
            GraphQLField("aliases", type: .list(.scalar(String.self))),
            GraphQLField("roles", type: .list(.object(Role.selections))),
            GraphQLField("talents", type: .list(.object(Talent.selections))),
            GraphQLField("stats", type: .object(Stat.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Short? = nil, name: String? = nil, displayName: String? = nil, shortName: String? = nil, aliases: [String?]? = nil, roles: [Role?]? = nil, talents: [Talent?]? = nil, stats: Stat? = nil) {
          self.init(unsafeResultMap: ["__typename": "HeroType", "id": id, "name": name, "displayName": displayName, "shortName": shortName, "aliases": aliases, "roles": roles.flatMap { (value: [Role?]) -> [ResultMap?] in value.map { (value: Role?) -> ResultMap? in value.flatMap { (value: Role) -> ResultMap in value.resultMap } } }, "talents": talents.flatMap { (value: [Talent?]) -> [ResultMap?] in value.map { (value: Talent?) -> ResultMap? in value.flatMap { (value: Talent) -> ResultMap in value.resultMap } } }, "stats": stats.flatMap { (value: Stat) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: Short? {
          get {
            return resultMap["id"] as? Short
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var displayName: String? {
          get {
            return resultMap["displayName"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "displayName")
          }
        }

        public var shortName: String? {
          get {
            return resultMap["shortName"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "shortName")
          }
        }

        public var aliases: [String?]? {
          get {
            return resultMap["aliases"] as? [String?]
          }
          set {
            resultMap.updateValue(newValue, forKey: "aliases")
          }
        }

        public var roles: [Role?]? {
          get {
            return (resultMap["roles"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Role?] in value.map { (value: ResultMap?) -> Role? in value.flatMap { (value: ResultMap) -> Role in Role(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Role?]) -> [ResultMap?] in value.map { (value: Role?) -> ResultMap? in value.flatMap { (value: Role) -> ResultMap in value.resultMap } } }, forKey: "roles")
          }
        }

        public var talents: [Talent?]? {
          get {
            return (resultMap["talents"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Talent?] in value.map { (value: ResultMap?) -> Talent? in value.flatMap { (value: ResultMap) -> Talent in Talent(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Talent?]) -> [ResultMap?] in value.map { (value: Talent?) -> ResultMap? in value.flatMap { (value: Talent) -> ResultMap in value.resultMap } } }, forKey: "talents")
          }
        }

        public var stats: Stat? {
          get {
            return (resultMap["stats"] as? ResultMap).flatMap { Stat(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "stats")
          }
        }

        public struct Role: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["HeroRoleType"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("roleId", type: .scalar(HeroRoleEnum.self)),
              GraphQLField("level", type: .scalar(Short.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(roleId: HeroRoleEnum? = nil, level: Short? = nil) {
            self.init(unsafeResultMap: ["__typename": "HeroRoleType", "roleId": roleId, "level": level])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var roleId: HeroRoleEnum? {
            get {
              return resultMap["roleId"] as? HeroRoleEnum
            }
            set {
              resultMap.updateValue(newValue, forKey: "roleId")
            }
          }

          public var level: Short? {
            get {
              return resultMap["level"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "level")
            }
          }
        }

        public struct Talent: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["HeroTalentType"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("abilityId", type: .scalar(Short.self)),
              GraphQLField("slot", type: .scalar(Byte.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(abilityId: Short? = nil, slot: Byte? = nil) {
            self.init(unsafeResultMap: ["__typename": "HeroTalentType", "abilityId": abilityId, "slot": slot])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var abilityId: Short? {
            get {
              return resultMap["abilityId"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "abilityId")
            }
          }

          public var slot: Byte? {
            get {
              return resultMap["slot"] as? Byte
            }
            set {
              resultMap.updateValue(newValue, forKey: "slot")
            }
          }
        }

        public struct Stat: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["HeroStatType"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("visionDaytimeRange", type: .scalar(Double.self)),
              GraphQLField("visionNighttimeRange", type: .scalar(Double.self)),
              GraphQLField("complexity", type: .scalar(Byte.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(visionDaytimeRange: Double? = nil, visionNighttimeRange: Double? = nil, complexity: Byte? = nil) {
            self.init(unsafeResultMap: ["__typename": "HeroStatType", "visionDaytimeRange": visionDaytimeRange, "visionNighttimeRange": visionNighttimeRange, "complexity": complexity])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var visionDaytimeRange: Double? {
            get {
              return resultMap["visionDaytimeRange"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "visionDaytimeRange")
            }
          }

          public var visionNighttimeRange: Double? {
            get {
              return resultMap["visionNighttimeRange"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "visionNighttimeRange")
            }
          }

          public var complexity: Byte? {
            get {
              return resultMap["complexity"] as? Byte
            }
            set {
              resultMap.updateValue(newValue, forKey: "complexity")
            }
          }
        }
      }
    }
  }
}
