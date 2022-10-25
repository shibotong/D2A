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

public struct LeagueRequestType: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - leagueId: A league id to include in this query, excluding all results that do not have this league id.
  ///   - leagueIds: An array of league ids to include in this query, excluding all results that do not include one of these leagues.
  ///   - tiers: An array of tier ids to include in this query, excluding all results that do not include one of these tiers.
  ///   - requireImage: Whether an image is required or not, represented in a boolean.
  ///   - requirePrizePool: Whether a prize pool is required or not, represented in a boolean.
  ///   - requireStartAndEndDates: Whether a start and end date is required or not, represented in a boolean.
  ///   - hasLiveMatches: Whether a league has live matches or not, represented in a boolean.
  ///   - leagueEnded: Whether a league has ended or not, represented in a boolean.
  ///   - isFutureLeague: Whether a league has started or not, represented in a boolean.
  ///   - startDateTime: If a league is set to start after this time.
  ///   - endDateTime: If a league is set to end before this time.
  ///   - betweenStartDateTime: Determine to Start value of finding a League Between two specific datetimes.
  ///   - betweenEndDateTime: Determine to End value of finding a League Between two specific datetimes.
  ///   - orderBy: The id to order the results by in this query.
  ///   - skip: The amount to skip before collecting your query. Hint: Paging
  ///   - take: The amount to have returned in your query. The maximum of this is always dynamic.
  public init(leagueId: Swift.Optional<Int?> = nil, leagueIds: Swift.Optional<[Int?]?> = nil, tiers: Swift.Optional<[LeagueTier?]?> = nil, requireImage: Swift.Optional<Bool?> = nil, requirePrizePool: Swift.Optional<Bool?> = nil, requireStartAndEndDates: Swift.Optional<Bool?> = nil, hasLiveMatches: Swift.Optional<Bool?> = nil, leagueEnded: Swift.Optional<Bool?> = nil, isFutureLeague: Swift.Optional<Bool?> = nil, startDateTime: Swift.Optional<Long?> = nil, endDateTime: Swift.Optional<Long?> = nil, betweenStartDateTime: Swift.Optional<Long?> = nil, betweenEndDateTime: Swift.Optional<Long?> = nil, orderBy: Swift.Optional<FilterOrderBy?> = nil, skip: Swift.Optional<Int?> = nil, take: Swift.Optional<Int?> = nil) {
    graphQLMap = ["leagueId": leagueId, "leagueIds": leagueIds, "tiers": tiers, "requireImage": requireImage, "requirePrizePool": requirePrizePool, "requireStartAndEndDates": requireStartAndEndDates, "hasLiveMatches": hasLiveMatches, "leagueEnded": leagueEnded, "isFutureLeague": isFutureLeague, "startDateTime": startDateTime, "endDateTime": endDateTime, "betweenStartDateTime": betweenStartDateTime, "betweenEndDateTime": betweenEndDateTime, "orderBy": orderBy, "skip": skip, "take": take]
  }

  /// A league id to include in this query, excluding all results that do not have this league id.
  public var leagueId: Swift.Optional<Int?> {
    get {
      return graphQLMap["leagueId"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "leagueId")
    }
  }

  /// An array of league ids to include in this query, excluding all results that do not include one of these leagues.
  public var leagueIds: Swift.Optional<[Int?]?> {
    get {
      return graphQLMap["leagueIds"] as? Swift.Optional<[Int?]?> ?? Swift.Optional<[Int?]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "leagueIds")
    }
  }

  /// An array of tier ids to include in this query, excluding all results that do not include one of these tiers.
  public var tiers: Swift.Optional<[LeagueTier?]?> {
    get {
      return graphQLMap["tiers"] as? Swift.Optional<[LeagueTier?]?> ?? Swift.Optional<[LeagueTier?]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tiers")
    }
  }

  /// Whether an image is required or not, represented in a boolean.
  public var requireImage: Swift.Optional<Bool?> {
    get {
      return graphQLMap["requireImage"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "requireImage")
    }
  }

  /// Whether a prize pool is required or not, represented in a boolean.
  public var requirePrizePool: Swift.Optional<Bool?> {
    get {
      return graphQLMap["requirePrizePool"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "requirePrizePool")
    }
  }

  /// Whether a start and end date is required or not, represented in a boolean.
  public var requireStartAndEndDates: Swift.Optional<Bool?> {
    get {
      return graphQLMap["requireStartAndEndDates"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "requireStartAndEndDates")
    }
  }

  /// Whether a league has live matches or not, represented in a boolean.
  public var hasLiveMatches: Swift.Optional<Bool?> {
    get {
      return graphQLMap["hasLiveMatches"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "hasLiveMatches")
    }
  }

  /// Whether a league has ended or not, represented in a boolean.
  public var leagueEnded: Swift.Optional<Bool?> {
    get {
      return graphQLMap["leagueEnded"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "leagueEnded")
    }
  }

  /// Whether a league has started or not, represented in a boolean.
  public var isFutureLeague: Swift.Optional<Bool?> {
    get {
      return graphQLMap["isFutureLeague"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isFutureLeague")
    }
  }

  /// If a league is set to start after this time.
  public var startDateTime: Swift.Optional<Long?> {
    get {
      return graphQLMap["startDateTime"] as? Swift.Optional<Long?> ?? Swift.Optional<Long?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "startDateTime")
    }
  }

  /// If a league is set to end before this time.
  public var endDateTime: Swift.Optional<Long?> {
    get {
      return graphQLMap["endDateTime"] as? Swift.Optional<Long?> ?? Swift.Optional<Long?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "endDateTime")
    }
  }

  /// Determine to Start value of finding a League Between two specific datetimes.
  public var betweenStartDateTime: Swift.Optional<Long?> {
    get {
      return graphQLMap["betweenStartDateTime"] as? Swift.Optional<Long?> ?? Swift.Optional<Long?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "betweenStartDateTime")
    }
  }

  /// Determine to End value of finding a League Between two specific datetimes.
  public var betweenEndDateTime: Swift.Optional<Long?> {
    get {
      return graphQLMap["betweenEndDateTime"] as? Swift.Optional<Long?> ?? Swift.Optional<Long?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "betweenEndDateTime")
    }
  }

  /// The id to order the results by in this query.
  public var orderBy: Swift.Optional<FilterOrderBy?> {
    get {
      return graphQLMap["orderBy"] as? Swift.Optional<FilterOrderBy?> ?? Swift.Optional<FilterOrderBy?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "orderBy")
    }
  }

  /// The amount to skip before collecting your query. Hint: Paging
  public var skip: Swift.Optional<Int?> {
    get {
      return graphQLMap["skip"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "skip")
    }
  }

  /// The amount to have returned in your query. The maximum of this is always dynamic.
  public var take: Swift.Optional<Int?> {
    get {
      return graphQLMap["take"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "take")
    }
  }
}

public enum LeagueTier: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case unset
  case amateur
  case professional
  case minor
  case major
  case international
  case dpcQualifier
  case dpcLeagueQualifier
  case dpcLeague
  case dpcLeagueFinals
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "UNSET": self = .unset
      case "AMATEUR": self = .amateur
      case "PROFESSIONAL": self = .professional
      case "MINOR": self = .minor
      case "MAJOR": self = .major
      case "INTERNATIONAL": self = .international
      case "DPC_QUALIFIER": self = .dpcQualifier
      case "DPC_LEAGUE_QUALIFIER": self = .dpcLeagueQualifier
      case "DPC_LEAGUE": self = .dpcLeague
      case "DPC_LEAGUE_FINALS": self = .dpcLeagueFinals
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .unset: return "UNSET"
      case .amateur: return "AMATEUR"
      case .professional: return "PROFESSIONAL"
      case .minor: return "MINOR"
      case .major: return "MAJOR"
      case .international: return "INTERNATIONAL"
      case .dpcQualifier: return "DPC_QUALIFIER"
      case .dpcLeagueQualifier: return "DPC_LEAGUE_QUALIFIER"
      case .dpcLeague: return "DPC_LEAGUE"
      case .dpcLeagueFinals: return "DPC_LEAGUE_FINALS"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: LeagueTier, rhs: LeagueTier) -> Bool {
    switch (lhs, rhs) {
      case (.unset, .unset): return true
      case (.amateur, .amateur): return true
      case (.professional, .professional): return true
      case (.minor, .minor): return true
      case (.major, .major): return true
      case (.international, .international): return true
      case (.dpcQualifier, .dpcQualifier): return true
      case (.dpcLeagueQualifier, .dpcLeagueQualifier): return true
      case (.dpcLeague, .dpcLeague): return true
      case (.dpcLeagueFinals, .dpcLeagueFinals): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [LeagueTier] {
    return [
      .unset,
      .amateur,
      .professional,
      .minor,
      .major,
      .international,
      .dpcQualifier,
      .dpcLeagueQualifier,
      .dpcLeague,
      .dpcLeagueFinals,
    ]
  }
}

public enum FilterOrderBy: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case lastMatchTime
  case id
  case `none`
  case startDateThenTier
  case lastMatchTimeThenTier
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "LAST_MATCH_TIME": self = .lastMatchTime
      case "ID": self = .id
      case "NONE": self = .none
      case "START_DATE_THEN_TIER": self = .startDateThenTier
      case "LAST_MATCH_TIME_THEN_TIER": self = .lastMatchTimeThenTier
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .lastMatchTime: return "LAST_MATCH_TIME"
      case .id: return "ID"
      case .none: return "NONE"
      case .startDateThenTier: return "START_DATE_THEN_TIER"
      case .lastMatchTimeThenTier: return "LAST_MATCH_TIME_THEN_TIER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: FilterOrderBy, rhs: FilterOrderBy) -> Bool {
    switch (lhs, rhs) {
      case (.lastMatchTime, .lastMatchTime): return true
      case (.id, .id): return true
      case (.none, .none): return true
      case (.startDateThenTier, .startDateThenTier): return true
      case (.lastMatchTimeThenTier, .lastMatchTimeThenTier): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [FilterOrderBy] {
    return [
      .lastMatchTime,
      .id,
      .none,
      .startDateThenTier,
      .lastMatchTimeThenTier,
    ]
  }
}

public enum LeagueNodeDefaultGroupEnum: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case invalid
  case bestOfOne
  case bestOfThree
  case bestOfFive
  case bestOfTwo
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "INVALID": self = .invalid
      case "BEST_OF_ONE": self = .bestOfOne
      case "BEST_OF_THREE": self = .bestOfThree
      case "BEST_OF_FIVE": self = .bestOfFive
      case "BEST_OF_TWO": self = .bestOfTwo
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .invalid: return "INVALID"
      case .bestOfOne: return "BEST_OF_ONE"
      case .bestOfThree: return "BEST_OF_THREE"
      case .bestOfFive: return "BEST_OF_FIVE"
      case .bestOfTwo: return "BEST_OF_TWO"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: LeagueNodeDefaultGroupEnum, rhs: LeagueNodeDefaultGroupEnum) -> Bool {
    switch (lhs, rhs) {
      case (.invalid, .invalid): return true
      case (.bestOfOne, .bestOfOne): return true
      case (.bestOfThree, .bestOfThree): return true
      case (.bestOfFive, .bestOfFive): return true
      case (.bestOfTwo, .bestOfTwo): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [LeagueNodeDefaultGroupEnum] {
    return [
      .invalid,
      .bestOfOne,
      .bestOfThree,
      .bestOfFive,
      .bestOfTwo,
    ]
  }
}

public enum LobbyTypeEnum: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case unranked
  case practice
  case tournament
  case tutorial
  case coopVsBots
  case teamMatch
  case soloQueue
  case ranked
  case soloMid
  case battleCup
  case event
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "UNRANKED": self = .unranked
      case "PRACTICE": self = .practice
      case "TOURNAMENT": self = .tournament
      case "TUTORIAL": self = .tutorial
      case "COOP_VS_BOTS": self = .coopVsBots
      case "TEAM_MATCH": self = .teamMatch
      case "SOLO_QUEUE": self = .soloQueue
      case "RANKED": self = .ranked
      case "SOLO_MID": self = .soloMid
      case "BATTLE_CUP": self = .battleCup
      case "EVENT": self = .event
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .unranked: return "UNRANKED"
      case .practice: return "PRACTICE"
      case .tournament: return "TOURNAMENT"
      case .tutorial: return "TUTORIAL"
      case .coopVsBots: return "COOP_VS_BOTS"
      case .teamMatch: return "TEAM_MATCH"
      case .soloQueue: return "SOLO_QUEUE"
      case .ranked: return "RANKED"
      case .soloMid: return "SOLO_MID"
      case .battleCup: return "BATTLE_CUP"
      case .event: return "EVENT"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: LobbyTypeEnum, rhs: LobbyTypeEnum) -> Bool {
    switch (lhs, rhs) {
      case (.unranked, .unranked): return true
      case (.practice, .practice): return true
      case (.tournament, .tournament): return true
      case (.tutorial, .tutorial): return true
      case (.coopVsBots, .coopVsBots): return true
      case (.teamMatch, .teamMatch): return true
      case (.soloQueue, .soloQueue): return true
      case (.ranked, .ranked): return true
      case (.soloMid, .soloMid): return true
      case (.battleCup, .battleCup): return true
      case (.event, .event): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [LobbyTypeEnum] {
    return [
      .unranked,
      .practice,
      .tournament,
      .tutorial,
      .coopVsBots,
      .teamMatch,
      .soloQueue,
      .ranked,
      .soloMid,
      .battleCup,
      .event,
    ]
  }
}

public enum MatchPlayerPositionType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case position_1
  case position_2
  case position_3
  case position_4
  case position_5
  case unknown
  case filtered
  case all
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "POSITION_1": self = .position_1
      case "POSITION_2": self = .position_2
      case "POSITION_3": self = .position_3
      case "POSITION_4": self = .position_4
      case "POSITION_5": self = .position_5
      case "UNKNOWN": self = .unknown
      case "FILTERED": self = .filtered
      case "ALL": self = .all
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .position_1: return "POSITION_1"
      case .position_2: return "POSITION_2"
      case .position_3: return "POSITION_3"
      case .position_4: return "POSITION_4"
      case .position_5: return "POSITION_5"
      case .unknown: return "UNKNOWN"
      case .filtered: return "FILTERED"
      case .all: return "ALL"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: MatchPlayerPositionType, rhs: MatchPlayerPositionType) -> Bool {
    switch (lhs, rhs) {
      case (.position_1, .position_1): return true
      case (.position_2, .position_2): return true
      case (.position_3, .position_3): return true
      case (.position_4, .position_4): return true
      case (.position_5, .position_5): return true
      case (.unknown, .unknown): return true
      case (.filtered, .filtered): return true
      case (.all, .all): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [MatchPlayerPositionType] {
    return [
      .position_1,
      .position_2,
      .position_3,
      .position_4,
      .position_5,
      .unknown,
      .filtered,
      .all,
    ]
  }
}

public enum GameModeEnumType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case `none`
  case allPick
  case captainsMode
  case randomDraft
  case singleDraft
  case allRandom
  case intro
  case theDiretide
  case reverseCaptainsMode
  case theGreeviling
  case tutorial
  case midOnly
  case leastPlayed
  case newPlayerPool
  case compendiumMatchmaking
  case custom
  case captainsDraft
  case balancedDraft
  case abilityDraft
  case event
  case allRandomDeathMatch
  case soloMid
  case allPickRanked
  case turbo
  case mutation
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "NONE": self = .none
      case "ALL_PICK": self = .allPick
      case "CAPTAINS_MODE": self = .captainsMode
      case "RANDOM_DRAFT": self = .randomDraft
      case "SINGLE_DRAFT": self = .singleDraft
      case "ALL_RANDOM": self = .allRandom
      case "INTRO": self = .intro
      case "THE_DIRETIDE": self = .theDiretide
      case "REVERSE_CAPTAINS_MODE": self = .reverseCaptainsMode
      case "THE_GREEVILING": self = .theGreeviling
      case "TUTORIAL": self = .tutorial
      case "MID_ONLY": self = .midOnly
      case "LEAST_PLAYED": self = .leastPlayed
      case "NEW_PLAYER_POOL": self = .newPlayerPool
      case "COMPENDIUM_MATCHMAKING": self = .compendiumMatchmaking
      case "CUSTOM": self = .custom
      case "CAPTAINS_DRAFT": self = .captainsDraft
      case "BALANCED_DRAFT": self = .balancedDraft
      case "ABILITY_DRAFT": self = .abilityDraft
      case "EVENT": self = .event
      case "ALL_RANDOM_DEATH_MATCH": self = .allRandomDeathMatch
      case "SOLO_MID": self = .soloMid
      case "ALL_PICK_RANKED": self = .allPickRanked
      case "TURBO": self = .turbo
      case "MUTATION": self = .mutation
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .none: return "NONE"
      case .allPick: return "ALL_PICK"
      case .captainsMode: return "CAPTAINS_MODE"
      case .randomDraft: return "RANDOM_DRAFT"
      case .singleDraft: return "SINGLE_DRAFT"
      case .allRandom: return "ALL_RANDOM"
      case .intro: return "INTRO"
      case .theDiretide: return "THE_DIRETIDE"
      case .reverseCaptainsMode: return "REVERSE_CAPTAINS_MODE"
      case .theGreeviling: return "THE_GREEVILING"
      case .tutorial: return "TUTORIAL"
      case .midOnly: return "MID_ONLY"
      case .leastPlayed: return "LEAST_PLAYED"
      case .newPlayerPool: return "NEW_PLAYER_POOL"
      case .compendiumMatchmaking: return "COMPENDIUM_MATCHMAKING"
      case .custom: return "CUSTOM"
      case .captainsDraft: return "CAPTAINS_DRAFT"
      case .balancedDraft: return "BALANCED_DRAFT"
      case .abilityDraft: return "ABILITY_DRAFT"
      case .event: return "EVENT"
      case .allRandomDeathMatch: return "ALL_RANDOM_DEATH_MATCH"
      case .soloMid: return "SOLO_MID"
      case .allPickRanked: return "ALL_PICK_RANKED"
      case .turbo: return "TURBO"
      case .mutation: return "MUTATION"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: GameModeEnumType, rhs: GameModeEnumType) -> Bool {
    switch (lhs, rhs) {
      case (.none, .none): return true
      case (.allPick, .allPick): return true
      case (.captainsMode, .captainsMode): return true
      case (.randomDraft, .randomDraft): return true
      case (.singleDraft, .singleDraft): return true
      case (.allRandom, .allRandom): return true
      case (.intro, .intro): return true
      case (.theDiretide, .theDiretide): return true
      case (.reverseCaptainsMode, .reverseCaptainsMode): return true
      case (.theGreeviling, .theGreeviling): return true
      case (.tutorial, .tutorial): return true
      case (.midOnly, .midOnly): return true
      case (.leastPlayed, .leastPlayed): return true
      case (.newPlayerPool, .newPlayerPool): return true
      case (.compendiumMatchmaking, .compendiumMatchmaking): return true
      case (.custom, .custom): return true
      case (.captainsDraft, .captainsDraft): return true
      case (.balancedDraft, .balancedDraft): return true
      case (.abilityDraft, .abilityDraft): return true
      case (.event, .event): return true
      case (.allRandomDeathMatch, .allRandomDeathMatch): return true
      case (.soloMid, .soloMid): return true
      case (.allPickRanked, .allPickRanked): return true
      case (.turbo, .turbo): return true
      case (.mutation, .mutation): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [GameModeEnumType] {
    return [
      .none,
      .allPick,
      .captainsMode,
      .randomDraft,
      .singleDraft,
      .allRandom,
      .intro,
      .theDiretide,
      .reverseCaptainsMode,
      .theGreeviling,
      .tutorial,
      .midOnly,
      .leastPlayed,
      .newPlayerPool,
      .compendiumMatchmaking,
      .custom,
      .captainsDraft,
      .balancedDraft,
      .abilityDraft,
      .event,
      .allRandomDeathMatch,
      .soloMid,
      .allPickRanked,
      .turbo,
      .mutation,
    ]
  }
}

public enum BuildingType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case fort
  case tower
  case barracks
  case healer
  case outpost
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "FORT": self = .fort
      case "TOWER": self = .tower
      case "BARRACKS": self = .barracks
      case "HEALER": self = .healer
      case "OUTPOST": self = .outpost
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .fort: return "FORT"
      case .tower: return "TOWER"
      case .barracks: return "BARRACKS"
      case .healer: return "HEALER"
      case .outpost: return "OUTPOST"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: BuildingType, rhs: BuildingType) -> Bool {
    switch (lhs, rhs) {
      case (.fort, .fort): return true
      case (.tower, .tower): return true
      case (.barracks, .barracks): return true
      case (.healer, .healer): return true
      case (.outpost, .outpost): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [BuildingType] {
    return [
      .fort,
      .tower,
      .barracks,
      .healer,
      .outpost,
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

public final class LeaguesListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query LeaguesList($leagueRequest: LeagueRequestType!) {
      leagues(request: $leagueRequest) {
        __typename
        id
        tier
        tournamentUrl
        hasLiveMatches
        prizePool
        displayName
        description
        nodeGroups {
          __typename
          id
          name
          nodes {
            __typename
            id
            scheduledTime
            actualTime
            teamOne {
              __typename
              id
              name
              tag
            }
            teamTwo {
              __typename
              id
              name
              tag
            }
            teamOneWins
            teamTwoWins
            hasStarted
            isCompleted
            nodeType
            matches {
              __typename
              id
            }
          }
        }
        liveMatches {
          __typename
          matchId
        }
        streams {
          __typename
          id
          languageId
          name
          streamUrl
        }
      }
    }
    """

  public let operationName: String = "LeaguesList"

  public var leagueRequest: LeagueRequestType

  public init(leagueRequest: LeagueRequestType) {
    self.leagueRequest = leagueRequest
  }

  public var variables: GraphQLMap? {
    return ["leagueRequest": leagueRequest]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["DotaQuery"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("leagues", arguments: ["request": GraphQLVariable("leagueRequest")], type: .list(.object(League.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(leagues: [League?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "DotaQuery", "leagues": leagues.flatMap { (value: [League?]) -> [ResultMap?] in value.map { (value: League?) -> ResultMap? in value.flatMap { (value: League) -> ResultMap in value.resultMap } } }])
    }

    /// Find league details by searching for leagues using a LeagueRequest.
    public var leagues: [League?]? {
      get {
        return (resultMap["leagues"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [League?] in value.map { (value: ResultMap?) -> League? in value.flatMap { (value: ResultMap) -> League in League(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [League?]) -> [ResultMap?] in value.map { (value: League?) -> ResultMap? in value.flatMap { (value: League) -> ResultMap in value.resultMap } } }, forKey: "leagues")
      }
    }

    public struct League: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["LeagueType"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(Int.self)),
          GraphQLField("tier", type: .scalar(LeagueTier.self)),
          GraphQLField("tournamentUrl", type: .scalar(String.self)),
          GraphQLField("hasLiveMatches", type: .scalar(Bool.self)),
          GraphQLField("prizePool", type: .scalar(Int.self)),
          GraphQLField("displayName", type: .scalar(String.self)),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("nodeGroups", type: .list(.object(NodeGroup.selections))),
          GraphQLField("liveMatches", type: .list(.object(LiveMatch.selections))),
          GraphQLField("streams", type: .list(.object(Stream.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: Int? = nil, tier: LeagueTier? = nil, tournamentUrl: String? = nil, hasLiveMatches: Bool? = nil, prizePool: Int? = nil, displayName: String? = nil, description: String? = nil, nodeGroups: [NodeGroup?]? = nil, liveMatches: [LiveMatch?]? = nil, streams: [Stream?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "LeagueType", "id": id, "tier": tier, "tournamentUrl": tournamentUrl, "hasLiveMatches": hasLiveMatches, "prizePool": prizePool, "displayName": displayName, "description": description, "nodeGroups": nodeGroups.flatMap { (value: [NodeGroup?]) -> [ResultMap?] in value.map { (value: NodeGroup?) -> ResultMap? in value.flatMap { (value: NodeGroup) -> ResultMap in value.resultMap } } }, "liveMatches": liveMatches.flatMap { (value: [LiveMatch?]) -> [ResultMap?] in value.map { (value: LiveMatch?) -> ResultMap? in value.flatMap { (value: LiveMatch) -> ResultMap in value.resultMap } } }, "streams": streams.flatMap { (value: [Stream?]) -> [ResultMap?] in value.map { (value: Stream?) -> ResultMap? in value.flatMap { (value: Stream) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: Int? {
        get {
          return resultMap["id"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var tier: LeagueTier? {
        get {
          return resultMap["tier"] as? LeagueTier
        }
        set {
          resultMap.updateValue(newValue, forKey: "tier")
        }
      }

      public var tournamentUrl: String? {
        get {
          return resultMap["tournamentUrl"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "tournamentUrl")
        }
      }

      public var hasLiveMatches: Bool? {
        get {
          return resultMap["hasLiveMatches"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "hasLiveMatches")
        }
      }

      public var prizePool: Int? {
        get {
          return resultMap["prizePool"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "prizePool")
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

      public var description: String? {
        get {
          return resultMap["description"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }

      public var nodeGroups: [NodeGroup?]? {
        get {
          return (resultMap["nodeGroups"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [NodeGroup?] in value.map { (value: ResultMap?) -> NodeGroup? in value.flatMap { (value: ResultMap) -> NodeGroup in NodeGroup(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [NodeGroup?]) -> [ResultMap?] in value.map { (value: NodeGroup?) -> ResultMap? in value.flatMap { (value: NodeGroup) -> ResultMap in value.resultMap } } }, forKey: "nodeGroups")
        }
      }

      public var liveMatches: [LiveMatch?]? {
        get {
          return (resultMap["liveMatches"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [LiveMatch?] in value.map { (value: ResultMap?) -> LiveMatch? in value.flatMap { (value: ResultMap) -> LiveMatch in LiveMatch(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [LiveMatch?]) -> [ResultMap?] in value.map { (value: LiveMatch?) -> ResultMap? in value.flatMap { (value: LiveMatch) -> ResultMap in value.resultMap } } }, forKey: "liveMatches")
        }
      }

      public var streams: [Stream?]? {
        get {
          return (resultMap["streams"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Stream?] in value.map { (value: ResultMap?) -> Stream? in value.flatMap { (value: ResultMap) -> Stream in Stream(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Stream?]) -> [ResultMap?] in value.map { (value: Stream?) -> ResultMap? in value.flatMap { (value: Stream) -> ResultMap in value.resultMap } } }, forKey: "streams")
        }
      }

      public struct NodeGroup: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["LeagueNodeGroupType"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(Short.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Short? = nil, name: String? = nil, nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "LeagueNodeGroupType", "id": id, "name": name, "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
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

        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["LeagueNodeType"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(Short.self)),
              GraphQLField("scheduledTime", type: .scalar(Long.self)),
              GraphQLField("actualTime", type: .scalar(Long.self)),
              GraphQLField("teamOne", type: .object(TeamOne.selections)),
              GraphQLField("teamTwo", type: .object(TeamTwo.selections)),
              GraphQLField("teamOneWins", type: .scalar(Byte.self)),
              GraphQLField("teamTwoWins", type: .scalar(Byte.self)),
              GraphQLField("hasStarted", type: .scalar(Bool.self)),
              GraphQLField("isCompleted", type: .scalar(Bool.self)),
              GraphQLField("nodeType", type: .scalar(LeagueNodeDefaultGroupEnum.self)),
              GraphQLField("matches", type: .list(.object(Match.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: Short? = nil, scheduledTime: Long? = nil, actualTime: Long? = nil, teamOne: TeamOne? = nil, teamTwo: TeamTwo? = nil, teamOneWins: Byte? = nil, teamTwoWins: Byte? = nil, hasStarted: Bool? = nil, isCompleted: Bool? = nil, nodeType: LeagueNodeDefaultGroupEnum? = nil, matches: [Match?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "LeagueNodeType", "id": id, "scheduledTime": scheduledTime, "actualTime": actualTime, "teamOne": teamOne.flatMap { (value: TeamOne) -> ResultMap in value.resultMap }, "teamTwo": teamTwo.flatMap { (value: TeamTwo) -> ResultMap in value.resultMap }, "teamOneWins": teamOneWins, "teamTwoWins": teamTwoWins, "hasStarted": hasStarted, "isCompleted": isCompleted, "nodeType": nodeType, "matches": matches.flatMap { (value: [Match?]) -> [ResultMap?] in value.map { (value: Match?) -> ResultMap? in value.flatMap { (value: Match) -> ResultMap in value.resultMap } } }])
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

          public var scheduledTime: Long? {
            get {
              return resultMap["scheduledTime"] as? Long
            }
            set {
              resultMap.updateValue(newValue, forKey: "scheduledTime")
            }
          }

          public var actualTime: Long? {
            get {
              return resultMap["actualTime"] as? Long
            }
            set {
              resultMap.updateValue(newValue, forKey: "actualTime")
            }
          }

          public var teamOne: TeamOne? {
            get {
              return (resultMap["teamOne"] as? ResultMap).flatMap { TeamOne(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "teamOne")
            }
          }

          public var teamTwo: TeamTwo? {
            get {
              return (resultMap["teamTwo"] as? ResultMap).flatMap { TeamTwo(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "teamTwo")
            }
          }

          public var teamOneWins: Byte? {
            get {
              return resultMap["teamOneWins"] as? Byte
            }
            set {
              resultMap.updateValue(newValue, forKey: "teamOneWins")
            }
          }

          public var teamTwoWins: Byte? {
            get {
              return resultMap["teamTwoWins"] as? Byte
            }
            set {
              resultMap.updateValue(newValue, forKey: "teamTwoWins")
            }
          }

          public var hasStarted: Bool? {
            get {
              return resultMap["hasStarted"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "hasStarted")
            }
          }

          public var isCompleted: Bool? {
            get {
              return resultMap["isCompleted"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "isCompleted")
            }
          }

          public var nodeType: LeagueNodeDefaultGroupEnum? {
            get {
              return resultMap["nodeType"] as? LeagueNodeDefaultGroupEnum
            }
            set {
              resultMap.updateValue(newValue, forKey: "nodeType")
            }
          }

          public var matches: [Match?]? {
            get {
              return (resultMap["matches"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Match?] in value.map { (value: ResultMap?) -> Match? in value.flatMap { (value: ResultMap) -> Match in Match(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Match?]) -> [ResultMap?] in value.map { (value: Match?) -> ResultMap? in value.flatMap { (value: Match) -> ResultMap in value.resultMap } } }, forKey: "matches")
            }
          }

          public struct TeamOne: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["TeamType"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(Int.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("tag", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: Int, name: String? = nil, tag: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "TeamType", "id": id, "name": name, "tag": tag])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: Int {
              get {
                return resultMap["id"]! as! Int
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

            public var tag: String? {
              get {
                return resultMap["tag"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "tag")
              }
            }
          }

          public struct TeamTwo: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["TeamType"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(Int.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("tag", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: Int, name: String? = nil, tag: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "TeamType", "id": id, "name": name, "tag": tag])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: Int {
              get {
                return resultMap["id"]! as! Int
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

            public var tag: String? {
              get {
                return resultMap["tag"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "tag")
              }
            }
          }

          public struct Match: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["MatchType"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .scalar(Long.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: Long? = nil) {
              self.init(unsafeResultMap: ["__typename": "MatchType", "id": id])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: Long? {
              get {
                return resultMap["id"] as? Long
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }
          }
        }
      }

      public struct LiveMatch: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MatchLiveType"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("matchId", type: .scalar(Long.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(matchId: Long? = nil) {
          self.init(unsafeResultMap: ["__typename": "MatchLiveType", "matchId": matchId])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var matchId: Long? {
          get {
            return resultMap["matchId"] as? Long
          }
          set {
            resultMap.updateValue(newValue, forKey: "matchId")
          }
        }
      }

      public struct Stream: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["LeagueStreamType"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(Int.self)),
            GraphQLField("languageId", type: .scalar(Language.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("streamUrl", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int? = nil, languageId: Language? = nil, name: String? = nil, streamUrl: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "LeagueStreamType", "id": id, "languageId": languageId, "name": name, "streamUrl": streamUrl])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: Int? {
          get {
            return resultMap["id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var languageId: Language? {
          get {
            return resultMap["languageId"] as? Language
          }
          set {
            resultMap.updateValue(newValue, forKey: "languageId")
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

        public var streamUrl: String? {
          get {
            return resultMap["streamUrl"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "streamUrl")
          }
        }
      }
    }
  }
}

public final class MatchLiveSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription MatchLive($id: Long!) {
      matchLive(matchId: $id) {
        __typename
        matchId
        radiantScore
        direScore
        leagueId
        delay
        averageRank
        buildingState
        radiantLead
        lobbyType
        gameTime
        completed
        isUpdating
        isParsing
        radiantTeam {
          __typename
          id
          name
          countryCode
          url
          logo
          baseLogo
          bannerLogo
        }
        direTeam {
          __typename
          id
          name
          countryCode
          url
          logo
          baseLogo
          bannerLogo
        }
        players {
          __typename
          steamAccountId
          steamAccount {
            __typename
            realName
            name
            seasonRank
            proSteamAccount {
              __typename
              name
              realName
            }
          }
          heroId
          name
          playerSlot
          isRadiant
          numKills
          numDeaths
          numAssists
          numLastHits
          numDenies
          goldPerMinute
          experiencePerMinute
          level
          gold
          heroDamage
          towerDamage
          itemId0
          itemId1
          itemId2
          itemId3
          itemId4
          itemId5
          backpackId0
          backpackId1
          backpackId2
          playbackData {
            __typename
            positionEvents {
              __typename
              time
              x
              y
            }
            killEvents {
              __typename
              time
            }
            deathEvents {
              __typename
              time
            }
            inventoryEvents {
              __typename
              time
              itemId0
              itemId1
              itemId2
              itemId3
              itemId4
              itemId5
              backpackId0
              backpackId1
              backpackId2
            }
          }
          networth
          position
        }
        gameMode
        gameMinute
        createdDateTime
        modifiedDateTime
        winRateValues
        durationValues
        liveWinRateValues {
          __typename
          time
          winRate
        }
        playbackData {
          __typename
          buildingEvents {
            __typename
            indexId
            isAlive
            isRadiant
            npcId
            positionX
            positionY
            time
            type
          }
          pickBans {
            __typename
            isPick
            heroId
            order
            bannedHeroId
            isRadiant
          }
        }
      }
    }
    """

  public let operationName: String = "MatchLive"

  public var id: Long

  public init(id: Long) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["DotaSubscription"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("matchLive", arguments: ["matchId": GraphQLVariable("id")], type: .object(MatchLive.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(matchLive: MatchLive? = nil) {
      self.init(unsafeResultMap: ["__typename": "DotaSubscription", "matchLive": matchLive.flatMap { (value: MatchLive) -> ResultMap in value.resultMap }])
    }

    public var matchLive: MatchLive? {
      get {
        return (resultMap["matchLive"] as? ResultMap).flatMap { MatchLive(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "matchLive")
      }
    }

    public struct MatchLive: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MatchLiveType"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("matchId", type: .scalar(Long.self)),
          GraphQLField("radiantScore", type: .scalar(Byte.self)),
          GraphQLField("direScore", type: .scalar(Byte.self)),
          GraphQLField("leagueId", type: .scalar(Int.self)),
          GraphQLField("delay", type: .scalar(Short.self)),
          GraphQLField("averageRank", type: .scalar(Int.self)),
          GraphQLField("buildingState", type: .scalar(Long.self)),
          GraphQLField("radiantLead", type: .scalar(Int.self)),
          GraphQLField("lobbyType", type: .scalar(LobbyTypeEnum.self)),
          GraphQLField("gameTime", type: .scalar(Int.self)),
          GraphQLField("completed", type: .scalar(Bool.self)),
          GraphQLField("isUpdating", type: .scalar(Bool.self)),
          GraphQLField("isParsing", type: .scalar(Bool.self)),
          GraphQLField("radiantTeam", type: .object(RadiantTeam.selections)),
          GraphQLField("direTeam", type: .object(DireTeam.selections)),
          GraphQLField("players", type: .list(.object(Player.selections))),
          GraphQLField("gameMode", type: .scalar(GameModeEnumType.self)),
          GraphQLField("gameMinute", type: .scalar(Short.self)),
          GraphQLField("createdDateTime", type: .scalar(Long.self)),
          GraphQLField("modifiedDateTime", type: .scalar(Long.self)),
          GraphQLField("winRateValues", type: .list(.scalar(Double.self))),
          GraphQLField("durationValues", type: .list(.scalar(Double.self))),
          GraphQLField("liveWinRateValues", type: .list(.object(LiveWinRateValue.selections))),
          GraphQLField("playbackData", type: .object(PlaybackDatum.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(matchId: Long? = nil, radiantScore: Byte? = nil, direScore: Byte? = nil, leagueId: Int? = nil, delay: Short? = nil, averageRank: Int? = nil, buildingState: Long? = nil, radiantLead: Int? = nil, lobbyType: LobbyTypeEnum? = nil, gameTime: Int? = nil, completed: Bool? = nil, isUpdating: Bool? = nil, isParsing: Bool? = nil, radiantTeam: RadiantTeam? = nil, direTeam: DireTeam? = nil, players: [Player?]? = nil, gameMode: GameModeEnumType? = nil, gameMinute: Short? = nil, createdDateTime: Long? = nil, modifiedDateTime: Long? = nil, winRateValues: [Double?]? = nil, durationValues: [Double?]? = nil, liveWinRateValues: [LiveWinRateValue?]? = nil, playbackData: PlaybackDatum? = nil) {
        self.init(unsafeResultMap: ["__typename": "MatchLiveType", "matchId": matchId, "radiantScore": radiantScore, "direScore": direScore, "leagueId": leagueId, "delay": delay, "averageRank": averageRank, "buildingState": buildingState, "radiantLead": radiantLead, "lobbyType": lobbyType, "gameTime": gameTime, "completed": completed, "isUpdating": isUpdating, "isParsing": isParsing, "radiantTeam": radiantTeam.flatMap { (value: RadiantTeam) -> ResultMap in value.resultMap }, "direTeam": direTeam.flatMap { (value: DireTeam) -> ResultMap in value.resultMap }, "players": players.flatMap { (value: [Player?]) -> [ResultMap?] in value.map { (value: Player?) -> ResultMap? in value.flatMap { (value: Player) -> ResultMap in value.resultMap } } }, "gameMode": gameMode, "gameMinute": gameMinute, "createdDateTime": createdDateTime, "modifiedDateTime": modifiedDateTime, "winRateValues": winRateValues, "durationValues": durationValues, "liveWinRateValues": liveWinRateValues.flatMap { (value: [LiveWinRateValue?]) -> [ResultMap?] in value.map { (value: LiveWinRateValue?) -> ResultMap? in value.flatMap { (value: LiveWinRateValue) -> ResultMap in value.resultMap } } }, "playbackData": playbackData.flatMap { (value: PlaybackDatum) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var matchId: Long? {
        get {
          return resultMap["matchId"] as? Long
        }
        set {
          resultMap.updateValue(newValue, forKey: "matchId")
        }
      }

      public var radiantScore: Byte? {
        get {
          return resultMap["radiantScore"] as? Byte
        }
        set {
          resultMap.updateValue(newValue, forKey: "radiantScore")
        }
      }

      public var direScore: Byte? {
        get {
          return resultMap["direScore"] as? Byte
        }
        set {
          resultMap.updateValue(newValue, forKey: "direScore")
        }
      }

      public var leagueId: Int? {
        get {
          return resultMap["leagueId"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "leagueId")
        }
      }

      public var delay: Short? {
        get {
          return resultMap["delay"] as? Short
        }
        set {
          resultMap.updateValue(newValue, forKey: "delay")
        }
      }

      public var averageRank: Int? {
        get {
          return resultMap["averageRank"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "averageRank")
        }
      }

      public var buildingState: Long? {
        get {
          return resultMap["buildingState"] as? Long
        }
        set {
          resultMap.updateValue(newValue, forKey: "buildingState")
        }
      }

      public var radiantLead: Int? {
        get {
          return resultMap["radiantLead"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "radiantLead")
        }
      }

      public var lobbyType: LobbyTypeEnum? {
        get {
          return resultMap["lobbyType"] as? LobbyTypeEnum
        }
        set {
          resultMap.updateValue(newValue, forKey: "lobbyType")
        }
      }

      public var gameTime: Int? {
        get {
          return resultMap["gameTime"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "gameTime")
        }
      }

      public var completed: Bool? {
        get {
          return resultMap["completed"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "completed")
        }
      }

      public var isUpdating: Bool? {
        get {
          return resultMap["isUpdating"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isUpdating")
        }
      }

      public var isParsing: Bool? {
        get {
          return resultMap["isParsing"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isParsing")
        }
      }

      public var radiantTeam: RadiantTeam? {
        get {
          return (resultMap["radiantTeam"] as? ResultMap).flatMap { RadiantTeam(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "radiantTeam")
        }
      }

      public var direTeam: DireTeam? {
        get {
          return (resultMap["direTeam"] as? ResultMap).flatMap { DireTeam(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "direTeam")
        }
      }

      public var players: [Player?]? {
        get {
          return (resultMap["players"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Player?] in value.map { (value: ResultMap?) -> Player? in value.flatMap { (value: ResultMap) -> Player in Player(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Player?]) -> [ResultMap?] in value.map { (value: Player?) -> ResultMap? in value.flatMap { (value: Player) -> ResultMap in value.resultMap } } }, forKey: "players")
        }
      }

      public var gameMode: GameModeEnumType? {
        get {
          return resultMap["gameMode"] as? GameModeEnumType
        }
        set {
          resultMap.updateValue(newValue, forKey: "gameMode")
        }
      }

      public var gameMinute: Short? {
        get {
          return resultMap["gameMinute"] as? Short
        }
        set {
          resultMap.updateValue(newValue, forKey: "gameMinute")
        }
      }

      public var createdDateTime: Long? {
        get {
          return resultMap["createdDateTime"] as? Long
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdDateTime")
        }
      }

      public var modifiedDateTime: Long? {
        get {
          return resultMap["modifiedDateTime"] as? Long
        }
        set {
          resultMap.updateValue(newValue, forKey: "modifiedDateTime")
        }
      }

      public var winRateValues: [Double?]? {
        get {
          return resultMap["winRateValues"] as? [Double?]
        }
        set {
          resultMap.updateValue(newValue, forKey: "winRateValues")
        }
      }

      public var durationValues: [Double?]? {
        get {
          return resultMap["durationValues"] as? [Double?]
        }
        set {
          resultMap.updateValue(newValue, forKey: "durationValues")
        }
      }

      public var liveWinRateValues: [LiveWinRateValue?]? {
        get {
          return (resultMap["liveWinRateValues"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [LiveWinRateValue?] in value.map { (value: ResultMap?) -> LiveWinRateValue? in value.flatMap { (value: ResultMap) -> LiveWinRateValue in LiveWinRateValue(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [LiveWinRateValue?]) -> [ResultMap?] in value.map { (value: LiveWinRateValue?) -> ResultMap? in value.flatMap { (value: LiveWinRateValue) -> ResultMap in value.resultMap } } }, forKey: "liveWinRateValues")
        }
      }

      public var playbackData: PlaybackDatum? {
        get {
          return (resultMap["playbackData"] as? ResultMap).flatMap { PlaybackDatum(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "playbackData")
        }
      }

      public struct RadiantTeam: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TeamType"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(Int.self))),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("countryCode", type: .scalar(String.self)),
            GraphQLField("url", type: .scalar(String.self)),
            GraphQLField("logo", type: .scalar(String.self)),
            GraphQLField("baseLogo", type: .scalar(String.self)),
            GraphQLField("bannerLogo", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int, name: String? = nil, countryCode: String? = nil, url: String? = nil, logo: String? = nil, baseLogo: String? = nil, bannerLogo: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "TeamType", "id": id, "name": name, "countryCode": countryCode, "url": url, "logo": logo, "baseLogo": baseLogo, "bannerLogo": bannerLogo])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: Int {
          get {
            return resultMap["id"]! as! Int
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

        public var countryCode: String? {
          get {
            return resultMap["countryCode"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "countryCode")
          }
        }

        public var url: String? {
          get {
            return resultMap["url"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "url")
          }
        }

        public var logo: String? {
          get {
            return resultMap["logo"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "logo")
          }
        }

        public var baseLogo: String? {
          get {
            return resultMap["baseLogo"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "baseLogo")
          }
        }

        public var bannerLogo: String? {
          get {
            return resultMap["bannerLogo"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "bannerLogo")
          }
        }
      }

      public struct DireTeam: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TeamType"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(Int.self))),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("countryCode", type: .scalar(String.self)),
            GraphQLField("url", type: .scalar(String.self)),
            GraphQLField("logo", type: .scalar(String.self)),
            GraphQLField("baseLogo", type: .scalar(String.self)),
            GraphQLField("bannerLogo", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int, name: String? = nil, countryCode: String? = nil, url: String? = nil, logo: String? = nil, baseLogo: String? = nil, bannerLogo: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "TeamType", "id": id, "name": name, "countryCode": countryCode, "url": url, "logo": logo, "baseLogo": baseLogo, "bannerLogo": bannerLogo])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: Int {
          get {
            return resultMap["id"]! as! Int
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

        public var countryCode: String? {
          get {
            return resultMap["countryCode"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "countryCode")
          }
        }

        public var url: String? {
          get {
            return resultMap["url"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "url")
          }
        }

        public var logo: String? {
          get {
            return resultMap["logo"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "logo")
          }
        }

        public var baseLogo: String? {
          get {
            return resultMap["baseLogo"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "baseLogo")
          }
        }

        public var bannerLogo: String? {
          get {
            return resultMap["bannerLogo"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "bannerLogo")
          }
        }
      }

      public struct Player: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MatchLivePlayerType"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("steamAccountId", type: .scalar(Long.self)),
            GraphQLField("steamAccount", type: .object(SteamAccount.selections)),
            GraphQLField("heroId", type: .scalar(Short.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("playerSlot", type: .scalar(Byte.self)),
            GraphQLField("isRadiant", type: .scalar(Bool.self)),
            GraphQLField("numKills", type: .scalar(Byte.self)),
            GraphQLField("numDeaths", type: .scalar(Byte.self)),
            GraphQLField("numAssists", type: .scalar(Byte.self)),
            GraphQLField("numLastHits", type: .scalar(UShort.self)),
            GraphQLField("numDenies", type: .scalar(UShort.self)),
            GraphQLField("goldPerMinute", type: .scalar(UShort.self)),
            GraphQLField("experiencePerMinute", type: .scalar(UShort.self)),
            GraphQLField("level", type: .scalar(Byte.self)),
            GraphQLField("gold", type: .scalar(Int.self)),
            GraphQLField("heroDamage", type: .scalar(Int.self)),
            GraphQLField("towerDamage", type: .scalar(Int.self)),
            GraphQLField("itemId0", type: .scalar(Short.self)),
            GraphQLField("itemId1", type: .scalar(Short.self)),
            GraphQLField("itemId2", type: .scalar(Short.self)),
            GraphQLField("itemId3", type: .scalar(Short.self)),
            GraphQLField("itemId4", type: .scalar(Short.self)),
            GraphQLField("itemId5", type: .scalar(Short.self)),
            GraphQLField("backpackId0", type: .scalar(Short.self)),
            GraphQLField("backpackId1", type: .scalar(Short.self)),
            GraphQLField("backpackId2", type: .scalar(Short.self)),
            GraphQLField("playbackData", type: .object(PlaybackDatum.selections)),
            GraphQLField("networth", type: .scalar(Int.self)),
            GraphQLField("position", type: .scalar(MatchPlayerPositionType.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(steamAccountId: Long? = nil, steamAccount: SteamAccount? = nil, heroId: Short? = nil, name: String? = nil, playerSlot: Byte? = nil, isRadiant: Bool? = nil, numKills: Byte? = nil, numDeaths: Byte? = nil, numAssists: Byte? = nil, numLastHits: UShort? = nil, numDenies: UShort? = nil, goldPerMinute: UShort? = nil, experiencePerMinute: UShort? = nil, level: Byte? = nil, gold: Int? = nil, heroDamage: Int? = nil, towerDamage: Int? = nil, itemId0: Short? = nil, itemId1: Short? = nil, itemId2: Short? = nil, itemId3: Short? = nil, itemId4: Short? = nil, itemId5: Short? = nil, backpackId0: Short? = nil, backpackId1: Short? = nil, backpackId2: Short? = nil, playbackData: PlaybackDatum? = nil, networth: Int? = nil, position: MatchPlayerPositionType? = nil) {
          self.init(unsafeResultMap: ["__typename": "MatchLivePlayerType", "steamAccountId": steamAccountId, "steamAccount": steamAccount.flatMap { (value: SteamAccount) -> ResultMap in value.resultMap }, "heroId": heroId, "name": name, "playerSlot": playerSlot, "isRadiant": isRadiant, "numKills": numKills, "numDeaths": numDeaths, "numAssists": numAssists, "numLastHits": numLastHits, "numDenies": numDenies, "goldPerMinute": goldPerMinute, "experiencePerMinute": experiencePerMinute, "level": level, "gold": gold, "heroDamage": heroDamage, "towerDamage": towerDamage, "itemId0": itemId0, "itemId1": itemId1, "itemId2": itemId2, "itemId3": itemId3, "itemId4": itemId4, "itemId5": itemId5, "backpackId0": backpackId0, "backpackId1": backpackId1, "backpackId2": backpackId2, "playbackData": playbackData.flatMap { (value: PlaybackDatum) -> ResultMap in value.resultMap }, "networth": networth, "position": position])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var steamAccountId: Long? {
          get {
            return resultMap["steamAccountId"] as? Long
          }
          set {
            resultMap.updateValue(newValue, forKey: "steamAccountId")
          }
        }

        public var steamAccount: SteamAccount? {
          get {
            return (resultMap["steamAccount"] as? ResultMap).flatMap { SteamAccount(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "steamAccount")
          }
        }

        public var heroId: Short? {
          get {
            return resultMap["heroId"] as? Short
          }
          set {
            resultMap.updateValue(newValue, forKey: "heroId")
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

        public var playerSlot: Byte? {
          get {
            return resultMap["playerSlot"] as? Byte
          }
          set {
            resultMap.updateValue(newValue, forKey: "playerSlot")
          }
        }

        public var isRadiant: Bool? {
          get {
            return resultMap["isRadiant"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "isRadiant")
          }
        }

        public var numKills: Byte? {
          get {
            return resultMap["numKills"] as? Byte
          }
          set {
            resultMap.updateValue(newValue, forKey: "numKills")
          }
        }

        public var numDeaths: Byte? {
          get {
            return resultMap["numDeaths"] as? Byte
          }
          set {
            resultMap.updateValue(newValue, forKey: "numDeaths")
          }
        }

        public var numAssists: Byte? {
          get {
            return resultMap["numAssists"] as? Byte
          }
          set {
            resultMap.updateValue(newValue, forKey: "numAssists")
          }
        }

        public var numLastHits: UShort? {
          get {
            return resultMap["numLastHits"] as? UShort
          }
          set {
            resultMap.updateValue(newValue, forKey: "numLastHits")
          }
        }

        public var numDenies: UShort? {
          get {
            return resultMap["numDenies"] as? UShort
          }
          set {
            resultMap.updateValue(newValue, forKey: "numDenies")
          }
        }

        public var goldPerMinute: UShort? {
          get {
            return resultMap["goldPerMinute"] as? UShort
          }
          set {
            resultMap.updateValue(newValue, forKey: "goldPerMinute")
          }
        }

        public var experiencePerMinute: UShort? {
          get {
            return resultMap["experiencePerMinute"] as? UShort
          }
          set {
            resultMap.updateValue(newValue, forKey: "experiencePerMinute")
          }
        }

        public var level: Byte? {
          get {
            return resultMap["level"] as? Byte
          }
          set {
            resultMap.updateValue(newValue, forKey: "level")
          }
        }

        public var gold: Int? {
          get {
            return resultMap["gold"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "gold")
          }
        }

        public var heroDamage: Int? {
          get {
            return resultMap["heroDamage"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "heroDamage")
          }
        }

        public var towerDamage: Int? {
          get {
            return resultMap["towerDamage"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "towerDamage")
          }
        }

        public var itemId0: Short? {
          get {
            return resultMap["itemId0"] as? Short
          }
          set {
            resultMap.updateValue(newValue, forKey: "itemId0")
          }
        }

        public var itemId1: Short? {
          get {
            return resultMap["itemId1"] as? Short
          }
          set {
            resultMap.updateValue(newValue, forKey: "itemId1")
          }
        }

        public var itemId2: Short? {
          get {
            return resultMap["itemId2"] as? Short
          }
          set {
            resultMap.updateValue(newValue, forKey: "itemId2")
          }
        }

        public var itemId3: Short? {
          get {
            return resultMap["itemId3"] as? Short
          }
          set {
            resultMap.updateValue(newValue, forKey: "itemId3")
          }
        }

        public var itemId4: Short? {
          get {
            return resultMap["itemId4"] as? Short
          }
          set {
            resultMap.updateValue(newValue, forKey: "itemId4")
          }
        }

        public var itemId5: Short? {
          get {
            return resultMap["itemId5"] as? Short
          }
          set {
            resultMap.updateValue(newValue, forKey: "itemId5")
          }
        }

        public var backpackId0: Short? {
          get {
            return resultMap["backpackId0"] as? Short
          }
          set {
            resultMap.updateValue(newValue, forKey: "backpackId0")
          }
        }

        public var backpackId1: Short? {
          get {
            return resultMap["backpackId1"] as? Short
          }
          set {
            resultMap.updateValue(newValue, forKey: "backpackId1")
          }
        }

        public var backpackId2: Short? {
          get {
            return resultMap["backpackId2"] as? Short
          }
          set {
            resultMap.updateValue(newValue, forKey: "backpackId2")
          }
        }

        public var playbackData: PlaybackDatum? {
          get {
            return (resultMap["playbackData"] as? ResultMap).flatMap { PlaybackDatum(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "playbackData")
          }
        }

        public var networth: Int? {
          get {
            return resultMap["networth"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "networth")
          }
        }

        public var position: MatchPlayerPositionType? {
          get {
            return resultMap["position"] as? MatchPlayerPositionType
          }
          set {
            resultMap.updateValue(newValue, forKey: "position")
          }
        }

        public struct SteamAccount: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["SteamAccountType"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("realName", type: .scalar(String.self)),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("seasonRank", type: .scalar(Byte.self)),
              GraphQLField("proSteamAccount", type: .object(ProSteamAccount.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(realName: String? = nil, name: String? = nil, seasonRank: Byte? = nil, proSteamAccount: ProSteamAccount? = nil) {
            self.init(unsafeResultMap: ["__typename": "SteamAccountType", "realName": realName, "name": name, "seasonRank": seasonRank, "proSteamAccount": proSteamAccount.flatMap { (value: ProSteamAccount) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var realName: String? {
            get {
              return resultMap["realName"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "realName")
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

          public var seasonRank: Byte? {
            get {
              return resultMap["seasonRank"] as? Byte
            }
            set {
              resultMap.updateValue(newValue, forKey: "seasonRank")
            }
          }

          public var proSteamAccount: ProSteamAccount? {
            get {
              return (resultMap["proSteamAccount"] as? ResultMap).flatMap { ProSteamAccount(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "proSteamAccount")
            }
          }

          public struct ProSteamAccount: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ProSteamAccountType"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("realName", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String? = nil, realName: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "ProSteamAccountType", "name": name, "realName": realName])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
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

            public var realName: String? {
              get {
                return resultMap["realName"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "realName")
              }
            }
          }
        }

        public struct PlaybackDatum: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["MatchPlayerLivePlaybackDataType"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("positionEvents", type: .list(.object(PositionEvent.selections))),
              GraphQLField("killEvents", type: .list(.object(KillEvent.selections))),
              GraphQLField("deathEvents", type: .list(.object(DeathEvent.selections))),
              GraphQLField("inventoryEvents", type: .list(.object(InventoryEvent.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(positionEvents: [PositionEvent?]? = nil, killEvents: [KillEvent?]? = nil, deathEvents: [DeathEvent?]? = nil, inventoryEvents: [InventoryEvent?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "MatchPlayerLivePlaybackDataType", "positionEvents": positionEvents.flatMap { (value: [PositionEvent?]) -> [ResultMap?] in value.map { (value: PositionEvent?) -> ResultMap? in value.flatMap { (value: PositionEvent) -> ResultMap in value.resultMap } } }, "killEvents": killEvents.flatMap { (value: [KillEvent?]) -> [ResultMap?] in value.map { (value: KillEvent?) -> ResultMap? in value.flatMap { (value: KillEvent) -> ResultMap in value.resultMap } } }, "deathEvents": deathEvents.flatMap { (value: [DeathEvent?]) -> [ResultMap?] in value.map { (value: DeathEvent?) -> ResultMap? in value.flatMap { (value: DeathEvent) -> ResultMap in value.resultMap } } }, "inventoryEvents": inventoryEvents.flatMap { (value: [InventoryEvent?]) -> [ResultMap?] in value.map { (value: InventoryEvent?) -> ResultMap? in value.flatMap { (value: InventoryEvent) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var positionEvents: [PositionEvent?]? {
            get {
              return (resultMap["positionEvents"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [PositionEvent?] in value.map { (value: ResultMap?) -> PositionEvent? in value.flatMap { (value: ResultMap) -> PositionEvent in PositionEvent(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [PositionEvent?]) -> [ResultMap?] in value.map { (value: PositionEvent?) -> ResultMap? in value.flatMap { (value: PositionEvent) -> ResultMap in value.resultMap } } }, forKey: "positionEvents")
            }
          }

          public var killEvents: [KillEvent?]? {
            get {
              return (resultMap["killEvents"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [KillEvent?] in value.map { (value: ResultMap?) -> KillEvent? in value.flatMap { (value: ResultMap) -> KillEvent in KillEvent(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [KillEvent?]) -> [ResultMap?] in value.map { (value: KillEvent?) -> ResultMap? in value.flatMap { (value: KillEvent) -> ResultMap in value.resultMap } } }, forKey: "killEvents")
            }
          }

          public var deathEvents: [DeathEvent?]? {
            get {
              return (resultMap["deathEvents"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [DeathEvent?] in value.map { (value: ResultMap?) -> DeathEvent? in value.flatMap { (value: ResultMap) -> DeathEvent in DeathEvent(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [DeathEvent?]) -> [ResultMap?] in value.map { (value: DeathEvent?) -> ResultMap? in value.flatMap { (value: DeathEvent) -> ResultMap in value.resultMap } } }, forKey: "deathEvents")
            }
          }

          public var inventoryEvents: [InventoryEvent?]? {
            get {
              return (resultMap["inventoryEvents"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [InventoryEvent?] in value.map { (value: ResultMap?) -> InventoryEvent? in value.flatMap { (value: ResultMap) -> InventoryEvent in InventoryEvent(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [InventoryEvent?]) -> [ResultMap?] in value.map { (value: InventoryEvent?) -> ResultMap? in value.flatMap { (value: InventoryEvent) -> ResultMap in value.resultMap } } }, forKey: "inventoryEvents")
            }
          }

          public struct PositionEvent: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["MatchLivePlayerPositionDetailType"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("time", type: .nonNull(.scalar(Int.self))),
                GraphQLField("x", type: .nonNull(.scalar(Int.self))),
                GraphQLField("y", type: .nonNull(.scalar(Int.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(time: Int, x: Int, y: Int) {
              self.init(unsafeResultMap: ["__typename": "MatchLivePlayerPositionDetailType", "time": time, "x": x, "y": y])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var time: Int {
              get {
                return resultMap["time"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "time")
              }
            }

            public var x: Int {
              get {
                return resultMap["x"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "x")
              }
            }

            public var y: Int {
              get {
                return resultMap["y"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "y")
              }
            }
          }

          public struct KillEvent: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["MatchLivePlayerKillDetailType"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("time", type: .nonNull(.scalar(Int.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(time: Int) {
              self.init(unsafeResultMap: ["__typename": "MatchLivePlayerKillDetailType", "time": time])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var time: Int {
              get {
                return resultMap["time"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "time")
              }
            }
          }

          public struct DeathEvent: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["MatchLivePlayerDeathDetailType"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("time", type: .nonNull(.scalar(Int.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(time: Int) {
              self.init(unsafeResultMap: ["__typename": "MatchLivePlayerDeathDetailType", "time": time])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var time: Int {
              get {
                return resultMap["time"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "time")
              }
            }
          }

          public struct InventoryEvent: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["MatchLivePlayerInventoryDetailType"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("time", type: .nonNull(.scalar(Int.self))),
                GraphQLField("itemId0", type: .scalar(Short.self)),
                GraphQLField("itemId1", type: .scalar(Short.self)),
                GraphQLField("itemId2", type: .scalar(Short.self)),
                GraphQLField("itemId3", type: .scalar(Short.self)),
                GraphQLField("itemId4", type: .scalar(Short.self)),
                GraphQLField("itemId5", type: .scalar(Short.self)),
                GraphQLField("backpackId0", type: .scalar(Short.self)),
                GraphQLField("backpackId1", type: .scalar(Short.self)),
                GraphQLField("backpackId2", type: .scalar(Short.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(time: Int, itemId0: Short? = nil, itemId1: Short? = nil, itemId2: Short? = nil, itemId3: Short? = nil, itemId4: Short? = nil, itemId5: Short? = nil, backpackId0: Short? = nil, backpackId1: Short? = nil, backpackId2: Short? = nil) {
              self.init(unsafeResultMap: ["__typename": "MatchLivePlayerInventoryDetailType", "time": time, "itemId0": itemId0, "itemId1": itemId1, "itemId2": itemId2, "itemId3": itemId3, "itemId4": itemId4, "itemId5": itemId5, "backpackId0": backpackId0, "backpackId1": backpackId1, "backpackId2": backpackId2])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var time: Int {
              get {
                return resultMap["time"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "time")
              }
            }

            public var itemId0: Short? {
              get {
                return resultMap["itemId0"] as? Short
              }
              set {
                resultMap.updateValue(newValue, forKey: "itemId0")
              }
            }

            public var itemId1: Short? {
              get {
                return resultMap["itemId1"] as? Short
              }
              set {
                resultMap.updateValue(newValue, forKey: "itemId1")
              }
            }

            public var itemId2: Short? {
              get {
                return resultMap["itemId2"] as? Short
              }
              set {
                resultMap.updateValue(newValue, forKey: "itemId2")
              }
            }

            public var itemId3: Short? {
              get {
                return resultMap["itemId3"] as? Short
              }
              set {
                resultMap.updateValue(newValue, forKey: "itemId3")
              }
            }

            public var itemId4: Short? {
              get {
                return resultMap["itemId4"] as? Short
              }
              set {
                resultMap.updateValue(newValue, forKey: "itemId4")
              }
            }

            public var itemId5: Short? {
              get {
                return resultMap["itemId5"] as? Short
              }
              set {
                resultMap.updateValue(newValue, forKey: "itemId5")
              }
            }

            public var backpackId0: Short? {
              get {
                return resultMap["backpackId0"] as? Short
              }
              set {
                resultMap.updateValue(newValue, forKey: "backpackId0")
              }
            }

            public var backpackId1: Short? {
              get {
                return resultMap["backpackId1"] as? Short
              }
              set {
                resultMap.updateValue(newValue, forKey: "backpackId1")
              }
            }

            public var backpackId2: Short? {
              get {
                return resultMap["backpackId2"] as? Short
              }
              set {
                resultMap.updateValue(newValue, forKey: "backpackId2")
              }
            }
          }
        }
      }

      public struct LiveWinRateValue: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MatchLiveWinRateDetailType"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("time", type: .nonNull(.scalar(Int.self))),
            GraphQLField("winRate", type: .nonNull(.scalar(Double.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(time: Int, winRate: Double) {
          self.init(unsafeResultMap: ["__typename": "MatchLiveWinRateDetailType", "time": time, "winRate": winRate])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var time: Int {
          get {
            return resultMap["time"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "time")
          }
        }

        public var winRate: Double {
          get {
            return resultMap["winRate"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "winRate")
          }
        }
      }

      public struct PlaybackDatum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MatchLivePlaybackDataType"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("buildingEvents", type: .list(.object(BuildingEvent.selections))),
            GraphQLField("pickBans", type: .list(.object(PickBan.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(buildingEvents: [BuildingEvent?]? = nil, pickBans: [PickBan?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "MatchLivePlaybackDataType", "buildingEvents": buildingEvents.flatMap { (value: [BuildingEvent?]) -> [ResultMap?] in value.map { (value: BuildingEvent?) -> ResultMap? in value.flatMap { (value: BuildingEvent) -> ResultMap in value.resultMap } } }, "pickBans": pickBans.flatMap { (value: [PickBan?]) -> [ResultMap?] in value.map { (value: PickBan?) -> ResultMap? in value.flatMap { (value: PickBan) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var buildingEvents: [BuildingEvent?]? {
          get {
            return (resultMap["buildingEvents"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [BuildingEvent?] in value.map { (value: ResultMap?) -> BuildingEvent? in value.flatMap { (value: ResultMap) -> BuildingEvent in BuildingEvent(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [BuildingEvent?]) -> [ResultMap?] in value.map { (value: BuildingEvent?) -> ResultMap? in value.flatMap { (value: BuildingEvent) -> ResultMap in value.resultMap } } }, forKey: "buildingEvents")
          }
        }

        public var pickBans: [PickBan?]? {
          get {
            return (resultMap["pickBans"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [PickBan?] in value.map { (value: ResultMap?) -> PickBan? in value.flatMap { (value: ResultMap) -> PickBan in PickBan(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [PickBan?]) -> [ResultMap?] in value.map { (value: PickBan?) -> ResultMap? in value.flatMap { (value: PickBan) -> ResultMap in value.resultMap } } }, forKey: "pickBans")
          }
        }

        public struct BuildingEvent: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["MatchLiveBuildingDetailType"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("indexId", type: .scalar(Int.self)),
              GraphQLField("isAlive", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("isRadiant", type: .scalar(Bool.self)),
              GraphQLField("npcId", type: .scalar(Int.self)),
              GraphQLField("positionX", type: .scalar(Int.self)),
              GraphQLField("positionY", type: .scalar(Int.self)),
              GraphQLField("time", type: .nonNull(.scalar(Int.self))),
              GraphQLField("type", type: .scalar(BuildingType.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(indexId: Int? = nil, isAlive: Bool, isRadiant: Bool? = nil, npcId: Int? = nil, positionX: Int? = nil, positionY: Int? = nil, time: Int, type: BuildingType? = nil) {
            self.init(unsafeResultMap: ["__typename": "MatchLiveBuildingDetailType", "indexId": indexId, "isAlive": isAlive, "isRadiant": isRadiant, "npcId": npcId, "positionX": positionX, "positionY": positionY, "time": time, "type": type])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var indexId: Int? {
            get {
              return resultMap["indexId"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "indexId")
            }
          }

          public var isAlive: Bool {
            get {
              return resultMap["isAlive"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "isAlive")
            }
          }

          public var isRadiant: Bool? {
            get {
              return resultMap["isRadiant"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "isRadiant")
            }
          }

          public var npcId: Int? {
            get {
              return resultMap["npcId"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "npcId")
            }
          }

          public var positionX: Int? {
            get {
              return resultMap["positionX"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "positionX")
            }
          }

          public var positionY: Int? {
            get {
              return resultMap["positionY"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "positionY")
            }
          }

          public var time: Int {
            get {
              return resultMap["time"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "time")
            }
          }

          public var type: BuildingType? {
            get {
              return resultMap["type"] as? BuildingType
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
            }
          }
        }

        public struct PickBan: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["MatchLivePickBanType"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("isPick", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("heroId", type: .scalar(Short.self)),
              GraphQLField("order", type: .scalar(Int.self)),
              GraphQLField("bannedHeroId", type: .scalar(Short.self)),
              GraphQLField("isRadiant", type: .scalar(Bool.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(isPick: Bool, heroId: Short? = nil, order: Int? = nil, bannedHeroId: Short? = nil, isRadiant: Bool? = nil) {
            self.init(unsafeResultMap: ["__typename": "MatchLivePickBanType", "isPick": isPick, "heroId": heroId, "order": order, "bannedHeroId": bannedHeroId, "isRadiant": isRadiant])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var isPick: Bool {
            get {
              return resultMap["isPick"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "isPick")
            }
          }

          public var heroId: Short? {
            get {
              return resultMap["heroId"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "heroId")
            }
          }

          public var order: Int? {
            get {
              return resultMap["order"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "order")
            }
          }

          public var bannedHeroId: Short? {
            get {
              return resultMap["bannedHeroId"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "bannedHeroId")
            }
          }

          public var isRadiant: Bool? {
            get {
              return resultMap["isRadiant"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "isRadiant")
            }
          }
        }
      }
    }
  }
}

public final class MatchLiveHistoryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query MatchLiveHistory($id: Long!) {
      live {
        __typename
        match(id: $id) {
          __typename
          playbackData {
            __typename
            buildingEvents {
              __typename
              indexId
              isAlive
              isRadiant
              npcId
              positionX
              positionY
              time
              type
            }
            pickBans {
              __typename
              isPick
              heroId
              order
              bannedHeroId
              isRadiant
            }
          }
          players {
            __typename
            steamAccountId
            steamAccount {
              __typename
              realName
              name
              seasonRank
              proSteamAccount {
                __typename
                name
                realName
              }
            }
            heroId
            name
            playerSlot
            isRadiant
            numKills
            numDeaths
            numAssists
            numLastHits
            numDenies
            goldPerMinute
            experiencePerMinute
            level
            gold
            heroDamage
            towerDamage
            itemId0
            itemId1
            itemId2
            itemId3
            itemId4
            itemId5
            backpackId0
            backpackId1
            backpackId2
            playbackData {
              __typename
              positionEvents {
                __typename
                time
                x
                y
              }
              killEvents {
                __typename
                time
              }
              deathEvents {
                __typename
                time
              }
              inventoryEvents {
                __typename
                time
                itemId0
                itemId1
                itemId2
                itemId3
                itemId4
                itemId5
                backpackId0
                backpackId1
                backpackId2
              }
            }
            networth
            position
          }
        }
      }
    }
    """

  public let operationName: String = "MatchLiveHistory"

  public var id: Long

  public init(id: Long) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["DotaQuery"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("live", type: .object(Live.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(live: Live? = nil) {
      self.init(unsafeResultMap: ["__typename": "DotaQuery", "live": live.flatMap { (value: Live) -> ResultMap in value.resultMap }])
    }

    /// Queries used to find live match data.
    public var live: Live? {
      get {
        return (resultMap["live"] as? ResultMap).flatMap { Live(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "live")
      }
    }

    public struct Live: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["LiveQuery"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("match", arguments: ["id": GraphQLVariable("id")], type: .object(Match.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(match: Match? = nil) {
        self.init(unsafeResultMap: ["__typename": "LiveQuery", "match": match.flatMap { (value: Match) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Find a live match by match id. A live match is data where a match is on the Dota watch list and still active. All League games are also Live. id is a required input field.
      public var match: Match? {
        get {
          return (resultMap["match"] as? ResultMap).flatMap { Match(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "match")
        }
      }

      public struct Match: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["MatchLiveType"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("playbackData", type: .object(PlaybackDatum.selections)),
            GraphQLField("players", type: .list(.object(Player.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(playbackData: PlaybackDatum? = nil, players: [Player?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "MatchLiveType", "playbackData": playbackData.flatMap { (value: PlaybackDatum) -> ResultMap in value.resultMap }, "players": players.flatMap { (value: [Player?]) -> [ResultMap?] in value.map { (value: Player?) -> ResultMap? in value.flatMap { (value: Player) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var playbackData: PlaybackDatum? {
          get {
            return (resultMap["playbackData"] as? ResultMap).flatMap { PlaybackDatum(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "playbackData")
          }
        }

        public var players: [Player?]? {
          get {
            return (resultMap["players"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Player?] in value.map { (value: ResultMap?) -> Player? in value.flatMap { (value: ResultMap) -> Player in Player(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Player?]) -> [ResultMap?] in value.map { (value: Player?) -> ResultMap? in value.flatMap { (value: Player) -> ResultMap in value.resultMap } } }, forKey: "players")
          }
        }

        public struct PlaybackDatum: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["MatchLivePlaybackDataType"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("buildingEvents", type: .list(.object(BuildingEvent.selections))),
              GraphQLField("pickBans", type: .list(.object(PickBan.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(buildingEvents: [BuildingEvent?]? = nil, pickBans: [PickBan?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "MatchLivePlaybackDataType", "buildingEvents": buildingEvents.flatMap { (value: [BuildingEvent?]) -> [ResultMap?] in value.map { (value: BuildingEvent?) -> ResultMap? in value.flatMap { (value: BuildingEvent) -> ResultMap in value.resultMap } } }, "pickBans": pickBans.flatMap { (value: [PickBan?]) -> [ResultMap?] in value.map { (value: PickBan?) -> ResultMap? in value.flatMap { (value: PickBan) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var buildingEvents: [BuildingEvent?]? {
            get {
              return (resultMap["buildingEvents"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [BuildingEvent?] in value.map { (value: ResultMap?) -> BuildingEvent? in value.flatMap { (value: ResultMap) -> BuildingEvent in BuildingEvent(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [BuildingEvent?]) -> [ResultMap?] in value.map { (value: BuildingEvent?) -> ResultMap? in value.flatMap { (value: BuildingEvent) -> ResultMap in value.resultMap } } }, forKey: "buildingEvents")
            }
          }

          public var pickBans: [PickBan?]? {
            get {
              return (resultMap["pickBans"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [PickBan?] in value.map { (value: ResultMap?) -> PickBan? in value.flatMap { (value: ResultMap) -> PickBan in PickBan(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [PickBan?]) -> [ResultMap?] in value.map { (value: PickBan?) -> ResultMap? in value.flatMap { (value: PickBan) -> ResultMap in value.resultMap } } }, forKey: "pickBans")
            }
          }

          public struct BuildingEvent: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["MatchLiveBuildingDetailType"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("indexId", type: .scalar(Int.self)),
                GraphQLField("isAlive", type: .nonNull(.scalar(Bool.self))),
                GraphQLField("isRadiant", type: .scalar(Bool.self)),
                GraphQLField("npcId", type: .scalar(Int.self)),
                GraphQLField("positionX", type: .scalar(Int.self)),
                GraphQLField("positionY", type: .scalar(Int.self)),
                GraphQLField("time", type: .nonNull(.scalar(Int.self))),
                GraphQLField("type", type: .scalar(BuildingType.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(indexId: Int? = nil, isAlive: Bool, isRadiant: Bool? = nil, npcId: Int? = nil, positionX: Int? = nil, positionY: Int? = nil, time: Int, type: BuildingType? = nil) {
              self.init(unsafeResultMap: ["__typename": "MatchLiveBuildingDetailType", "indexId": indexId, "isAlive": isAlive, "isRadiant": isRadiant, "npcId": npcId, "positionX": positionX, "positionY": positionY, "time": time, "type": type])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var indexId: Int? {
              get {
                return resultMap["indexId"] as? Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "indexId")
              }
            }

            public var isAlive: Bool {
              get {
                return resultMap["isAlive"]! as! Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "isAlive")
              }
            }

            public var isRadiant: Bool? {
              get {
                return resultMap["isRadiant"] as? Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "isRadiant")
              }
            }

            public var npcId: Int? {
              get {
                return resultMap["npcId"] as? Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "npcId")
              }
            }

            public var positionX: Int? {
              get {
                return resultMap["positionX"] as? Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "positionX")
              }
            }

            public var positionY: Int? {
              get {
                return resultMap["positionY"] as? Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "positionY")
              }
            }

            public var time: Int {
              get {
                return resultMap["time"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "time")
              }
            }

            public var type: BuildingType? {
              get {
                return resultMap["type"] as? BuildingType
              }
              set {
                resultMap.updateValue(newValue, forKey: "type")
              }
            }
          }

          public struct PickBan: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["MatchLivePickBanType"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("isPick", type: .nonNull(.scalar(Bool.self))),
                GraphQLField("heroId", type: .scalar(Short.self)),
                GraphQLField("order", type: .scalar(Int.self)),
                GraphQLField("bannedHeroId", type: .scalar(Short.self)),
                GraphQLField("isRadiant", type: .scalar(Bool.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(isPick: Bool, heroId: Short? = nil, order: Int? = nil, bannedHeroId: Short? = nil, isRadiant: Bool? = nil) {
              self.init(unsafeResultMap: ["__typename": "MatchLivePickBanType", "isPick": isPick, "heroId": heroId, "order": order, "bannedHeroId": bannedHeroId, "isRadiant": isRadiant])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var isPick: Bool {
              get {
                return resultMap["isPick"]! as! Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "isPick")
              }
            }

            public var heroId: Short? {
              get {
                return resultMap["heroId"] as? Short
              }
              set {
                resultMap.updateValue(newValue, forKey: "heroId")
              }
            }

            public var order: Int? {
              get {
                return resultMap["order"] as? Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "order")
              }
            }

            public var bannedHeroId: Short? {
              get {
                return resultMap["bannedHeroId"] as? Short
              }
              set {
                resultMap.updateValue(newValue, forKey: "bannedHeroId")
              }
            }

            public var isRadiant: Bool? {
              get {
                return resultMap["isRadiant"] as? Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "isRadiant")
              }
            }
          }
        }

        public struct Player: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["MatchLivePlayerType"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("steamAccountId", type: .scalar(Long.self)),
              GraphQLField("steamAccount", type: .object(SteamAccount.selections)),
              GraphQLField("heroId", type: .scalar(Short.self)),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("playerSlot", type: .scalar(Byte.self)),
              GraphQLField("isRadiant", type: .scalar(Bool.self)),
              GraphQLField("numKills", type: .scalar(Byte.self)),
              GraphQLField("numDeaths", type: .scalar(Byte.self)),
              GraphQLField("numAssists", type: .scalar(Byte.self)),
              GraphQLField("numLastHits", type: .scalar(UShort.self)),
              GraphQLField("numDenies", type: .scalar(UShort.self)),
              GraphQLField("goldPerMinute", type: .scalar(UShort.self)),
              GraphQLField("experiencePerMinute", type: .scalar(UShort.self)),
              GraphQLField("level", type: .scalar(Byte.self)),
              GraphQLField("gold", type: .scalar(Int.self)),
              GraphQLField("heroDamage", type: .scalar(Int.self)),
              GraphQLField("towerDamage", type: .scalar(Int.self)),
              GraphQLField("itemId0", type: .scalar(Short.self)),
              GraphQLField("itemId1", type: .scalar(Short.self)),
              GraphQLField("itemId2", type: .scalar(Short.self)),
              GraphQLField("itemId3", type: .scalar(Short.self)),
              GraphQLField("itemId4", type: .scalar(Short.self)),
              GraphQLField("itemId5", type: .scalar(Short.self)),
              GraphQLField("backpackId0", type: .scalar(Short.self)),
              GraphQLField("backpackId1", type: .scalar(Short.self)),
              GraphQLField("backpackId2", type: .scalar(Short.self)),
              GraphQLField("playbackData", type: .object(PlaybackDatum.selections)),
              GraphQLField("networth", type: .scalar(Int.self)),
              GraphQLField("position", type: .scalar(MatchPlayerPositionType.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(steamAccountId: Long? = nil, steamAccount: SteamAccount? = nil, heroId: Short? = nil, name: String? = nil, playerSlot: Byte? = nil, isRadiant: Bool? = nil, numKills: Byte? = nil, numDeaths: Byte? = nil, numAssists: Byte? = nil, numLastHits: UShort? = nil, numDenies: UShort? = nil, goldPerMinute: UShort? = nil, experiencePerMinute: UShort? = nil, level: Byte? = nil, gold: Int? = nil, heroDamage: Int? = nil, towerDamage: Int? = nil, itemId0: Short? = nil, itemId1: Short? = nil, itemId2: Short? = nil, itemId3: Short? = nil, itemId4: Short? = nil, itemId5: Short? = nil, backpackId0: Short? = nil, backpackId1: Short? = nil, backpackId2: Short? = nil, playbackData: PlaybackDatum? = nil, networth: Int? = nil, position: MatchPlayerPositionType? = nil) {
            self.init(unsafeResultMap: ["__typename": "MatchLivePlayerType", "steamAccountId": steamAccountId, "steamAccount": steamAccount.flatMap { (value: SteamAccount) -> ResultMap in value.resultMap }, "heroId": heroId, "name": name, "playerSlot": playerSlot, "isRadiant": isRadiant, "numKills": numKills, "numDeaths": numDeaths, "numAssists": numAssists, "numLastHits": numLastHits, "numDenies": numDenies, "goldPerMinute": goldPerMinute, "experiencePerMinute": experiencePerMinute, "level": level, "gold": gold, "heroDamage": heroDamage, "towerDamage": towerDamage, "itemId0": itemId0, "itemId1": itemId1, "itemId2": itemId2, "itemId3": itemId3, "itemId4": itemId4, "itemId5": itemId5, "backpackId0": backpackId0, "backpackId1": backpackId1, "backpackId2": backpackId2, "playbackData": playbackData.flatMap { (value: PlaybackDatum) -> ResultMap in value.resultMap }, "networth": networth, "position": position])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var steamAccountId: Long? {
            get {
              return resultMap["steamAccountId"] as? Long
            }
            set {
              resultMap.updateValue(newValue, forKey: "steamAccountId")
            }
          }

          public var steamAccount: SteamAccount? {
            get {
              return (resultMap["steamAccount"] as? ResultMap).flatMap { SteamAccount(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "steamAccount")
            }
          }

          public var heroId: Short? {
            get {
              return resultMap["heroId"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "heroId")
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

          public var playerSlot: Byte? {
            get {
              return resultMap["playerSlot"] as? Byte
            }
            set {
              resultMap.updateValue(newValue, forKey: "playerSlot")
            }
          }

          public var isRadiant: Bool? {
            get {
              return resultMap["isRadiant"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "isRadiant")
            }
          }

          public var numKills: Byte? {
            get {
              return resultMap["numKills"] as? Byte
            }
            set {
              resultMap.updateValue(newValue, forKey: "numKills")
            }
          }

          public var numDeaths: Byte? {
            get {
              return resultMap["numDeaths"] as? Byte
            }
            set {
              resultMap.updateValue(newValue, forKey: "numDeaths")
            }
          }

          public var numAssists: Byte? {
            get {
              return resultMap["numAssists"] as? Byte
            }
            set {
              resultMap.updateValue(newValue, forKey: "numAssists")
            }
          }

          public var numLastHits: UShort? {
            get {
              return resultMap["numLastHits"] as? UShort
            }
            set {
              resultMap.updateValue(newValue, forKey: "numLastHits")
            }
          }

          public var numDenies: UShort? {
            get {
              return resultMap["numDenies"] as? UShort
            }
            set {
              resultMap.updateValue(newValue, forKey: "numDenies")
            }
          }

          public var goldPerMinute: UShort? {
            get {
              return resultMap["goldPerMinute"] as? UShort
            }
            set {
              resultMap.updateValue(newValue, forKey: "goldPerMinute")
            }
          }

          public var experiencePerMinute: UShort? {
            get {
              return resultMap["experiencePerMinute"] as? UShort
            }
            set {
              resultMap.updateValue(newValue, forKey: "experiencePerMinute")
            }
          }

          public var level: Byte? {
            get {
              return resultMap["level"] as? Byte
            }
            set {
              resultMap.updateValue(newValue, forKey: "level")
            }
          }

          public var gold: Int? {
            get {
              return resultMap["gold"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "gold")
            }
          }

          public var heroDamage: Int? {
            get {
              return resultMap["heroDamage"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "heroDamage")
            }
          }

          public var towerDamage: Int? {
            get {
              return resultMap["towerDamage"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "towerDamage")
            }
          }

          public var itemId0: Short? {
            get {
              return resultMap["itemId0"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "itemId0")
            }
          }

          public var itemId1: Short? {
            get {
              return resultMap["itemId1"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "itemId1")
            }
          }

          public var itemId2: Short? {
            get {
              return resultMap["itemId2"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "itemId2")
            }
          }

          public var itemId3: Short? {
            get {
              return resultMap["itemId3"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "itemId3")
            }
          }

          public var itemId4: Short? {
            get {
              return resultMap["itemId4"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "itemId4")
            }
          }

          public var itemId5: Short? {
            get {
              return resultMap["itemId5"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "itemId5")
            }
          }

          public var backpackId0: Short? {
            get {
              return resultMap["backpackId0"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "backpackId0")
            }
          }

          public var backpackId1: Short? {
            get {
              return resultMap["backpackId1"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "backpackId1")
            }
          }

          public var backpackId2: Short? {
            get {
              return resultMap["backpackId2"] as? Short
            }
            set {
              resultMap.updateValue(newValue, forKey: "backpackId2")
            }
          }

          public var playbackData: PlaybackDatum? {
            get {
              return (resultMap["playbackData"] as? ResultMap).flatMap { PlaybackDatum(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "playbackData")
            }
          }

          public var networth: Int? {
            get {
              return resultMap["networth"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "networth")
            }
          }

          public var position: MatchPlayerPositionType? {
            get {
              return resultMap["position"] as? MatchPlayerPositionType
            }
            set {
              resultMap.updateValue(newValue, forKey: "position")
            }
          }

          public struct SteamAccount: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["SteamAccountType"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("realName", type: .scalar(String.self)),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("seasonRank", type: .scalar(Byte.self)),
                GraphQLField("proSteamAccount", type: .object(ProSteamAccount.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(realName: String? = nil, name: String? = nil, seasonRank: Byte? = nil, proSteamAccount: ProSteamAccount? = nil) {
              self.init(unsafeResultMap: ["__typename": "SteamAccountType", "realName": realName, "name": name, "seasonRank": seasonRank, "proSteamAccount": proSteamAccount.flatMap { (value: ProSteamAccount) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var realName: String? {
              get {
                return resultMap["realName"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "realName")
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

            public var seasonRank: Byte? {
              get {
                return resultMap["seasonRank"] as? Byte
              }
              set {
                resultMap.updateValue(newValue, forKey: "seasonRank")
              }
            }

            public var proSteamAccount: ProSteamAccount? {
              get {
                return (resultMap["proSteamAccount"] as? ResultMap).flatMap { ProSteamAccount(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "proSteamAccount")
              }
            }

            public struct ProSteamAccount: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ProSteamAccountType"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("name", type: .scalar(String.self)),
                  GraphQLField("realName", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(name: String? = nil, realName: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "ProSteamAccountType", "name": name, "realName": realName])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
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

              public var realName: String? {
                get {
                  return resultMap["realName"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "realName")
                }
              }
            }
          }

          public struct PlaybackDatum: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["MatchPlayerLivePlaybackDataType"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("positionEvents", type: .list(.object(PositionEvent.selections))),
                GraphQLField("killEvents", type: .list(.object(KillEvent.selections))),
                GraphQLField("deathEvents", type: .list(.object(DeathEvent.selections))),
                GraphQLField("inventoryEvents", type: .list(.object(InventoryEvent.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(positionEvents: [PositionEvent?]? = nil, killEvents: [KillEvent?]? = nil, deathEvents: [DeathEvent?]? = nil, inventoryEvents: [InventoryEvent?]? = nil) {
              self.init(unsafeResultMap: ["__typename": "MatchPlayerLivePlaybackDataType", "positionEvents": positionEvents.flatMap { (value: [PositionEvent?]) -> [ResultMap?] in value.map { (value: PositionEvent?) -> ResultMap? in value.flatMap { (value: PositionEvent) -> ResultMap in value.resultMap } } }, "killEvents": killEvents.flatMap { (value: [KillEvent?]) -> [ResultMap?] in value.map { (value: KillEvent?) -> ResultMap? in value.flatMap { (value: KillEvent) -> ResultMap in value.resultMap } } }, "deathEvents": deathEvents.flatMap { (value: [DeathEvent?]) -> [ResultMap?] in value.map { (value: DeathEvent?) -> ResultMap? in value.flatMap { (value: DeathEvent) -> ResultMap in value.resultMap } } }, "inventoryEvents": inventoryEvents.flatMap { (value: [InventoryEvent?]) -> [ResultMap?] in value.map { (value: InventoryEvent?) -> ResultMap? in value.flatMap { (value: InventoryEvent) -> ResultMap in value.resultMap } } }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var positionEvents: [PositionEvent?]? {
              get {
                return (resultMap["positionEvents"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [PositionEvent?] in value.map { (value: ResultMap?) -> PositionEvent? in value.flatMap { (value: ResultMap) -> PositionEvent in PositionEvent(unsafeResultMap: value) } } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [PositionEvent?]) -> [ResultMap?] in value.map { (value: PositionEvent?) -> ResultMap? in value.flatMap { (value: PositionEvent) -> ResultMap in value.resultMap } } }, forKey: "positionEvents")
              }
            }

            public var killEvents: [KillEvent?]? {
              get {
                return (resultMap["killEvents"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [KillEvent?] in value.map { (value: ResultMap?) -> KillEvent? in value.flatMap { (value: ResultMap) -> KillEvent in KillEvent(unsafeResultMap: value) } } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [KillEvent?]) -> [ResultMap?] in value.map { (value: KillEvent?) -> ResultMap? in value.flatMap { (value: KillEvent) -> ResultMap in value.resultMap } } }, forKey: "killEvents")
              }
            }

            public var deathEvents: [DeathEvent?]? {
              get {
                return (resultMap["deathEvents"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [DeathEvent?] in value.map { (value: ResultMap?) -> DeathEvent? in value.flatMap { (value: ResultMap) -> DeathEvent in DeathEvent(unsafeResultMap: value) } } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [DeathEvent?]) -> [ResultMap?] in value.map { (value: DeathEvent?) -> ResultMap? in value.flatMap { (value: DeathEvent) -> ResultMap in value.resultMap } } }, forKey: "deathEvents")
              }
            }

            public var inventoryEvents: [InventoryEvent?]? {
              get {
                return (resultMap["inventoryEvents"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [InventoryEvent?] in value.map { (value: ResultMap?) -> InventoryEvent? in value.flatMap { (value: ResultMap) -> InventoryEvent in InventoryEvent(unsafeResultMap: value) } } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [InventoryEvent?]) -> [ResultMap?] in value.map { (value: InventoryEvent?) -> ResultMap? in value.flatMap { (value: InventoryEvent) -> ResultMap in value.resultMap } } }, forKey: "inventoryEvents")
              }
            }

            public struct PositionEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["MatchLivePlayerPositionDetailType"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("time", type: .nonNull(.scalar(Int.self))),
                  GraphQLField("x", type: .nonNull(.scalar(Int.self))),
                  GraphQLField("y", type: .nonNull(.scalar(Int.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(time: Int, x: Int, y: Int) {
                self.init(unsafeResultMap: ["__typename": "MatchLivePlayerPositionDetailType", "time": time, "x": x, "y": y])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var time: Int {
                get {
                  return resultMap["time"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "time")
                }
              }

              public var x: Int {
                get {
                  return resultMap["x"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "x")
                }
              }

              public var y: Int {
                get {
                  return resultMap["y"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "y")
                }
              }
            }

            public struct KillEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["MatchLivePlayerKillDetailType"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("time", type: .nonNull(.scalar(Int.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(time: Int) {
                self.init(unsafeResultMap: ["__typename": "MatchLivePlayerKillDetailType", "time": time])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var time: Int {
                get {
                  return resultMap["time"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "time")
                }
              }
            }

            public struct DeathEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["MatchLivePlayerDeathDetailType"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("time", type: .nonNull(.scalar(Int.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(time: Int) {
                self.init(unsafeResultMap: ["__typename": "MatchLivePlayerDeathDetailType", "time": time])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var time: Int {
                get {
                  return resultMap["time"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "time")
                }
              }
            }

            public struct InventoryEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["MatchLivePlayerInventoryDetailType"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("time", type: .nonNull(.scalar(Int.self))),
                  GraphQLField("itemId0", type: .scalar(Short.self)),
                  GraphQLField("itemId1", type: .scalar(Short.self)),
                  GraphQLField("itemId2", type: .scalar(Short.self)),
                  GraphQLField("itemId3", type: .scalar(Short.self)),
                  GraphQLField("itemId4", type: .scalar(Short.self)),
                  GraphQLField("itemId5", type: .scalar(Short.self)),
                  GraphQLField("backpackId0", type: .scalar(Short.self)),
                  GraphQLField("backpackId1", type: .scalar(Short.self)),
                  GraphQLField("backpackId2", type: .scalar(Short.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(time: Int, itemId0: Short? = nil, itemId1: Short? = nil, itemId2: Short? = nil, itemId3: Short? = nil, itemId4: Short? = nil, itemId5: Short? = nil, backpackId0: Short? = nil, backpackId1: Short? = nil, backpackId2: Short? = nil) {
                self.init(unsafeResultMap: ["__typename": "MatchLivePlayerInventoryDetailType", "time": time, "itemId0": itemId0, "itemId1": itemId1, "itemId2": itemId2, "itemId3": itemId3, "itemId4": itemId4, "itemId5": itemId5, "backpackId0": backpackId0, "backpackId1": backpackId1, "backpackId2": backpackId2])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var time: Int {
                get {
                  return resultMap["time"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "time")
                }
              }

              public var itemId0: Short? {
                get {
                  return resultMap["itemId0"] as? Short
                }
                set {
                  resultMap.updateValue(newValue, forKey: "itemId0")
                }
              }

              public var itemId1: Short? {
                get {
                  return resultMap["itemId1"] as? Short
                }
                set {
                  resultMap.updateValue(newValue, forKey: "itemId1")
                }
              }

              public var itemId2: Short? {
                get {
                  return resultMap["itemId2"] as? Short
                }
                set {
                  resultMap.updateValue(newValue, forKey: "itemId2")
                }
              }

              public var itemId3: Short? {
                get {
                  return resultMap["itemId3"] as? Short
                }
                set {
                  resultMap.updateValue(newValue, forKey: "itemId3")
                }
              }

              public var itemId4: Short? {
                get {
                  return resultMap["itemId4"] as? Short
                }
                set {
                  resultMap.updateValue(newValue, forKey: "itemId4")
                }
              }

              public var itemId5: Short? {
                get {
                  return resultMap["itemId5"] as? Short
                }
                set {
                  resultMap.updateValue(newValue, forKey: "itemId5")
                }
              }

              public var backpackId0: Short? {
                get {
                  return resultMap["backpackId0"] as? Short
                }
                set {
                  resultMap.updateValue(newValue, forKey: "backpackId0")
                }
              }

              public var backpackId1: Short? {
                get {
                  return resultMap["backpackId1"] as? Short
                }
                set {
                  resultMap.updateValue(newValue, forKey: "backpackId1")
                }
              }

              public var backpackId2: Short? {
                get {
                  return resultMap["backpackId2"] as? Short
                }
                set {
                  resultMap.updateValue(newValue, forKey: "backpackId2")
                }
              }
            }
          }
        }
      }
    }
  }
}
