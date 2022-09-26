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
          language {
            __typename
            displayName
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
            GraphQLField("language", type: .object(Language.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Short? = nil, language: Language? = nil) {
          self.init(unsafeResultMap: ["__typename": "AbilityType", "id": id, "language": language.flatMap { (value: Language) -> ResultMap in value.resultMap }])
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
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(displayName: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "AbilityLanguageType", "displayName": displayName])
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
          talents {
            __typename
            abilityId
            slot
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
            GraphQLField("talents", type: .list(.object(Talent.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(talents: [Talent?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "HeroType", "talents": talents.flatMap { (value: [Talent?]) -> [ResultMap?] in value.map { (value: Talent?) -> ResultMap? in value.flatMap { (value: Talent) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
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
      }
    }
  }
}
