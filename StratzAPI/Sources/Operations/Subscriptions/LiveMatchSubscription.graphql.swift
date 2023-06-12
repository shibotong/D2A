// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LiveMatchSubscription: GraphQLSubscription {
  public static let operationName: String = "LiveMatch"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      subscription LiveMatch($matchid: Long!) {
        matchLive(matchId: $matchid) {
          __typename
          matchId
          radiantScore
          direScore
          gameTime
          completed
          radiantTeamId
          direTeamId
          playbackData {
            __typename
            roshanEvents {
              __typename
              time
              isAlive
              respawnTimer
            }
            buildingEvents {
              __typename
              time
              indexId
              type
              isAlive
              positionX
              positionY
              isRadiant
              npcId
            }
            pickBans {
              __typename
              isPick
              heroId
              order
              bannedHeroId
              isRadiant
              letter
              baseWinRate
              adjustedWinRate
            }
          }
          gameState
          players {
            __typename
            heroId
            name
            steamAccountId
            steamAccount {
              __typename
              name
              realName
              avatar
              rankShift
              seasonRank
              proSteamAccount {
                __typename
                name
                realName
              }
            }
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
            itemId0
            itemId1
            itemId2
            itemId3
            itemId4
            itemId5
            backpackId0
            backpackId1
            backpackId2
            networth
            heroDamage
            playbackData {
              __typename
              killEvents {
                __typename
                time
              }
              deathEvents {
                __typename
                time
              }
              positionEvents {
                __typename
                time
                x
                y
              }
            }
          }
          winRateValues
          liveWinRateValues {
            __typename
            time
            winRate
          }
        }
      }
      """#
    ))

  public var matchid: Long

  public init(matchid: Long) {
    self.matchid = matchid
  }

  public var __variables: Variables? { ["matchid": matchid] }

  public struct Data: StratzAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.DotaSubscription }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("matchLive", MatchLive?.self, arguments: ["matchId": .variable("matchid")]),
    ] }

    public var matchLive: MatchLive? { __data["matchLive"] }

    /// MatchLive
    ///
    /// Parent Type: `MatchLiveType`
    public struct MatchLive: StratzAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchLiveType }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("matchId", StratzAPI.Long?.self),
        .field("radiantScore", StratzAPI.Byte?.self),
        .field("direScore", StratzAPI.Byte?.self),
        .field("gameTime", Int?.self),
        .field("completed", Bool?.self),
        .field("radiantTeamId", Int?.self),
        .field("direTeamId", Int?.self),
        .field("playbackData", PlaybackData?.self),
        .field("gameState", GraphQLEnum<StratzAPI.MatchLiveGameState>?.self),
        .field("players", [Player?]?.self),
        .field("winRateValues", [Double?]?.self),
        .field("liveWinRateValues", [LiveWinRateValue?]?.self),
      ] }

      public var matchId: StratzAPI.Long? { __data["matchId"] }
      public var radiantScore: StratzAPI.Byte? { __data["radiantScore"] }
      public var direScore: StratzAPI.Byte? { __data["direScore"] }
      public var gameTime: Int? { __data["gameTime"] }
      public var completed: Bool? { __data["completed"] }
      public var radiantTeamId: Int? { __data["radiantTeamId"] }
      public var direTeamId: Int? { __data["direTeamId"] }
      public var playbackData: PlaybackData? { __data["playbackData"] }
      public var gameState: GraphQLEnum<StratzAPI.MatchLiveGameState>? { __data["gameState"] }
      public var players: [Player?]? { __data["players"] }
      public var winRateValues: [Double?]? { __data["winRateValues"] }
      public var liveWinRateValues: [LiveWinRateValue?]? { __data["liveWinRateValues"] }

      /// MatchLive.PlaybackData
      ///
      /// Parent Type: `MatchLivePlaybackDataType`
      public struct PlaybackData: StratzAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchLivePlaybackDataType }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("roshanEvents", [RoshanEvent?]?.self),
          .field("buildingEvents", [BuildingEvent?]?.self),
          .field("pickBans", [PickBan?]?.self),
        ] }

        public var roshanEvents: [RoshanEvent?]? { __data["roshanEvents"] }
        public var buildingEvents: [BuildingEvent?]? { __data["buildingEvents"] }
        public var pickBans: [PickBan?]? { __data["pickBans"] }

        /// MatchLive.PlaybackData.RoshanEvent
        ///
        /// Parent Type: `MatchLiveRoshanDetailType`
        public struct RoshanEvent: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchLiveRoshanDetailType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("time", Int?.self),
            .field("isAlive", Bool?.self),
            .field("respawnTimer", Int?.self),
          ] }

          public var time: Int? { __data["time"] }
          public var isAlive: Bool? { __data["isAlive"] }
          public var respawnTimer: Int? { __data["respawnTimer"] }
        }

        /// MatchLive.PlaybackData.BuildingEvent
        ///
        /// Parent Type: `MatchLiveBuildingDetailType`
        public struct BuildingEvent: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchLiveBuildingDetailType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("time", Int.self),
            .field("indexId", Int?.self),
            .field("type", GraphQLEnum<StratzAPI.BuildingType>?.self),
            .field("isAlive", Bool.self),
            .field("positionX", Int?.self),
            .field("positionY", Int?.self),
            .field("isRadiant", Bool?.self),
            .field("npcId", Int?.self),
          ] }

          public var time: Int { __data["time"] }
          public var indexId: Int? { __data["indexId"] }
          public var type: GraphQLEnum<StratzAPI.BuildingType>? { __data["type"] }
          public var isAlive: Bool { __data["isAlive"] }
          public var positionX: Int? { __data["positionX"] }
          public var positionY: Int? { __data["positionY"] }
          public var isRadiant: Bool? { __data["isRadiant"] }
          public var npcId: Int? { __data["npcId"] }
        }

        /// MatchLive.PlaybackData.PickBan
        ///
        /// Parent Type: `MatchLivePickBanType`
        public struct PickBan: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchLivePickBanType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("isPick", Bool.self),
            .field("heroId", StratzAPI.Short?.self),
            .field("order", Int?.self),
            .field("bannedHeroId", StratzAPI.Short?.self),
            .field("isRadiant", Bool?.self),
            .field("letter", GraphQLEnum<StratzAPI.PlusLetterType>?.self),
            .field("baseWinRate", Double?.self),
            .field("adjustedWinRate", Double?.self),
          ] }

          public var isPick: Bool { __data["isPick"] }
          public var heroId: StratzAPI.Short? { __data["heroId"] }
          public var order: Int? { __data["order"] }
          public var bannedHeroId: StratzAPI.Short? { __data["bannedHeroId"] }
          public var isRadiant: Bool? { __data["isRadiant"] }
          public var letter: GraphQLEnum<StratzAPI.PlusLetterType>? { __data["letter"] }
          public var baseWinRate: Double? { __data["baseWinRate"] }
          public var adjustedWinRate: Double? { __data["adjustedWinRate"] }
        }
      }

      /// MatchLive.Player
      ///
      /// Parent Type: `MatchLivePlayerType`
      public struct Player: StratzAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchLivePlayerType }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("heroId", StratzAPI.Short?.self),
          .field("name", String?.self),
          .field("steamAccountId", StratzAPI.Long?.self),
          .field("steamAccount", SteamAccount?.self),
          .field("playerSlot", StratzAPI.Byte?.self),
          .field("isRadiant", Bool?.self),
          .field("numKills", StratzAPI.Byte?.self),
          .field("numDeaths", StratzAPI.Byte?.self),
          .field("numAssists", StratzAPI.Byte?.self),
          .field("numLastHits", StratzAPI.UShort?.self),
          .field("numDenies", StratzAPI.UShort?.self),
          .field("goldPerMinute", StratzAPI.UShort?.self),
          .field("experiencePerMinute", StratzAPI.UShort?.self),
          .field("level", StratzAPI.Byte?.self),
          .field("itemId0", StratzAPI.Short?.self),
          .field("itemId1", StratzAPI.Short?.self),
          .field("itemId2", StratzAPI.Short?.self),
          .field("itemId3", StratzAPI.Short?.self),
          .field("itemId4", StratzAPI.Short?.self),
          .field("itemId5", StratzAPI.Short?.self),
          .field("backpackId0", StratzAPI.Short?.self),
          .field("backpackId1", StratzAPI.Short?.self),
          .field("backpackId2", StratzAPI.Short?.self),
          .field("networth", Int?.self),
          .field("heroDamage", Int?.self),
          .field("playbackData", PlaybackData?.self),
        ] }

        public var heroId: StratzAPI.Short? { __data["heroId"] }
        public var name: String? { __data["name"] }
        public var steamAccountId: StratzAPI.Long? { __data["steamAccountId"] }
        public var steamAccount: SteamAccount? { __data["steamAccount"] }
        public var playerSlot: StratzAPI.Byte? { __data["playerSlot"] }
        public var isRadiant: Bool? { __data["isRadiant"] }
        public var numKills: StratzAPI.Byte? { __data["numKills"] }
        public var numDeaths: StratzAPI.Byte? { __data["numDeaths"] }
        public var numAssists: StratzAPI.Byte? { __data["numAssists"] }
        public var numLastHits: StratzAPI.UShort? { __data["numLastHits"] }
        public var numDenies: StratzAPI.UShort? { __data["numDenies"] }
        public var goldPerMinute: StratzAPI.UShort? { __data["goldPerMinute"] }
        public var experiencePerMinute: StratzAPI.UShort? { __data["experiencePerMinute"] }
        public var level: StratzAPI.Byte? { __data["level"] }
        public var itemId0: StratzAPI.Short? { __data["itemId0"] }
        public var itemId1: StratzAPI.Short? { __data["itemId1"] }
        public var itemId2: StratzAPI.Short? { __data["itemId2"] }
        public var itemId3: StratzAPI.Short? { __data["itemId3"] }
        public var itemId4: StratzAPI.Short? { __data["itemId4"] }
        public var itemId5: StratzAPI.Short? { __data["itemId5"] }
        public var backpackId0: StratzAPI.Short? { __data["backpackId0"] }
        public var backpackId1: StratzAPI.Short? { __data["backpackId1"] }
        public var backpackId2: StratzAPI.Short? { __data["backpackId2"] }
        public var networth: Int? { __data["networth"] }
        public var heroDamage: Int? { __data["heroDamage"] }
        public var playbackData: PlaybackData? { __data["playbackData"] }

        /// MatchLive.Player.SteamAccount
        ///
        /// Parent Type: `SteamAccountType`
        public struct SteamAccount: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.SteamAccountType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String?.self),
            .field("realName", String?.self),
            .field("avatar", String?.self),
            .field("rankShift", StratzAPI.Short?.self),
            .field("seasonRank", StratzAPI.Byte?.self),
            .field("proSteamAccount", ProSteamAccount?.self),
          ] }

          public var name: String? { __data["name"] }
          public var realName: String? { __data["realName"] }
          public var avatar: String? { __data["avatar"] }
          public var rankShift: StratzAPI.Short? { __data["rankShift"] }
          public var seasonRank: StratzAPI.Byte? { __data["seasonRank"] }
          public var proSteamAccount: ProSteamAccount? { __data["proSteamAccount"] }

          /// MatchLive.Player.SteamAccount.ProSteamAccount
          ///
          /// Parent Type: `ProSteamAccountType`
          public struct ProSteamAccount: StratzAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.ProSteamAccountType }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", String?.self),
              .field("realName", String?.self),
            ] }

            public var name: String? { __data["name"] }
            public var realName: String? { __data["realName"] }
          }
        }

        /// MatchLive.Player.PlaybackData
        ///
        /// Parent Type: `MatchPlayerLivePlaybackDataType`
        public struct PlaybackData: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchPlayerLivePlaybackDataType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("killEvents", [KillEvent?]?.self),
            .field("deathEvents", [DeathEvent?]?.self),
            .field("positionEvents", [PositionEvent?]?.self),
          ] }

          public var killEvents: [KillEvent?]? { __data["killEvents"] }
          public var deathEvents: [DeathEvent?]? { __data["deathEvents"] }
          public var positionEvents: [PositionEvent?]? { __data["positionEvents"] }

          /// MatchLive.Player.PlaybackData.KillEvent
          ///
          /// Parent Type: `MatchLivePlayerKillDetailType`
          public struct KillEvent: StratzAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchLivePlayerKillDetailType }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("time", Int.self),
            ] }

            public var time: Int { __data["time"] }
          }

          /// MatchLive.Player.PlaybackData.DeathEvent
          ///
          /// Parent Type: `MatchLivePlayerDeathDetailType`
          public struct DeathEvent: StratzAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchLivePlayerDeathDetailType }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("time", Int.self),
            ] }

            public var time: Int { __data["time"] }
          }

          /// MatchLive.Player.PlaybackData.PositionEvent
          ///
          /// Parent Type: `MatchLivePlayerPositionDetailType`
          public struct PositionEvent: StratzAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchLivePlayerPositionDetailType }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("time", Int.self),
              .field("x", Int.self),
              .field("y", Int.self),
            ] }

            public var time: Int { __data["time"] }
            public var x: Int { __data["x"] }
            public var y: Int { __data["y"] }
          }
        }
      }

      /// MatchLive.LiveWinRateValue
      ///
      /// Parent Type: `MatchLiveWinRateDetailType`
      public struct LiveWinRateValue: StratzAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchLiveWinRateDetailType }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("time", Int.self),
          .field("winRate", Double.self),
        ] }

        public var time: Int { __data["time"] }
        public var winRate: Double { __data["winRate"] }
      }
    }
  }
}
