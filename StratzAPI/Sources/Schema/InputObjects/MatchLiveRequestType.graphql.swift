// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct MatchLiveRequestType: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    heroId: GraphQLNullable<Short> = nil,
    leagueId: GraphQLNullable<Int> = nil,
    isParsing: GraphQLNullable<Bool> = nil,
    isCompleted: GraphQLNullable<Bool> = nil,
    leagueIds: GraphQLNullable<[Int?]> = nil,
    gameStates: GraphQLNullable<[GraphQLEnum<MatchLiveGameState>?]> = nil,
    tiers: GraphQLNullable<[GraphQLEnum<LeagueTier>?]> = nil,
    lastPlaybackEventOnly: GraphQLNullable<Bool> = nil,
    orderBy: GraphQLNullable<GraphQLEnum<MatchLiveRequestOrderBy>> = nil,
    isLeague: GraphQLNullable<Bool> = nil,
    take: GraphQLNullable<Int> = nil,
    skip: GraphQLNullable<Int> = nil
  ) {
    __data = InputDict([
      "heroId": heroId,
      "leagueId": leagueId,
      "isParsing": isParsing,
      "isCompleted": isCompleted,
      "leagueIds": leagueIds,
      "gameStates": gameStates,
      "tiers": tiers,
      "lastPlaybackEventOnly": lastPlaybackEventOnly,
      "orderBy": orderBy,
      "isLeague": isLeague,
      "take": take,
      "skip": skip
    ])
  }

  /// The hero id to include in this query, excluding all results that do not include this hero.
  public var heroId: GraphQLNullable<Short> {
    get { __data["heroId"] }
    set { __data["heroId"] = newValue }
  }

  /// A league id to include in this query, excluding all results that do not have this league id.
  public var leagueId: GraphQLNullable<Int> {
    get { __data["leagueId"] }
    set { __data["leagueId"] = newValue }
  }

  /// Returns only matches that are currently still being updated by the backend.
  public var isParsing: GraphQLNullable<Bool> {
    get { __data["isParsing"] }
    set { __data["isParsing"] = newValue }
  }

  /// Returns only matches that are no longer active and completed but not yet deleted.
  public var isCompleted: GraphQLNullable<Bool> {
    get { __data["isCompleted"] }
    set { __data["isCompleted"] = newValue }
  }

  /// An array of league ids to include in this query, excluding all results that do not include one of these leagues.
  public var leagueIds: GraphQLNullable<[Int?]> {
    get { __data["leagueIds"] }
    set { __data["leagueIds"] = newValue }
  }

  /// Only return Live Matches In Progress that are currently in these states.
  public var gameStates: GraphQLNullable<[GraphQLEnum<MatchLiveGameState>?]> {
    get { __data["gameStates"] }
    set { __data["gameStates"] = newValue }
  }

  /// An array of tier ids to include in this query, excluding all results that do not include one of these tiers.
  public var tiers: GraphQLNullable<[GraphQLEnum<LeagueTier>?]> {
    get { __data["tiers"] }
    set { __data["tiers"] = newValue }
  }

  /// Playback Data can contain a lot of information. This will only display the most recent event for each of the fields.
  public var lastPlaybackEventOnly: GraphQLNullable<Bool> {
    get { __data["lastPlaybackEventOnly"] }
    set { __data["lastPlaybackEventOnly"] = newValue }
  }

  /// The order in which the data returned will be sorted by.
  public var orderBy: GraphQLNullable<GraphQLEnum<MatchLiveRequestOrderBy>> {
    get { __data["orderBy"] }
    set { __data["orderBy"] = newValue }
  }

  /// Whether the match is a league match or not.
  public var isLeague: GraphQLNullable<Bool> {
    get { __data["isLeague"] }
    set { __data["isLeague"] = newValue }
  }

  /// The amount to have returned in your query. The maximum of this is always dynamic. Limit : 
  public var take: GraphQLNullable<Int> {
    get { __data["take"] }
    set { __data["take"] = newValue }
  }

  /// The amount of data to skip before collecting your query. This is useful for Paging.
  public var skip: GraphQLNullable<Int> {
    get { __data["skip"] }
    set { __data["skip"] = newValue }
  }
}
