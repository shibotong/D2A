// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LiveMatchHistoryQuery: GraphQLQuery {
  public static let operationName: String = "LiveMatchHistory"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      query LiveMatchHistory($matchid: Long!) {
        live {
          __typename
          match(id: $matchid) {
            __typename
            radiantTeamId
            direTeamId
            gameMode
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
              }
            }
            gameState
            players {
              __typename
              heroId
              name
              playerSlot
              isRadiant
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
            }
            liveWinRateValues {
              __typename
              time
              winRate
            }
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

    public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.DotaQuery }
    public static var __selections: [ApolloAPI.Selection] {
      [
        .field("live", Live?.self)
      ]
    }

    /// Queries used to find live match data.
    public var live: Live? { __data["live"] }

    /// Live
    ///
    /// Parent Type: `LiveQuery`
    public struct Live: StratzAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.LiveQuery }
      public static var __selections: [ApolloAPI.Selection] {
        [
          .field("__typename", String.self),
          .field("match", Match?.self, arguments: ["id": .variable("matchid")]),
        ]
      }

      /// Find a live match by match id. A live match is data where a match is on the Dota watch list and still active. All League games are also Live. id is a required input field.
      public var match: Match? { __data["match"] }

      /// Live.Match
      ///
      /// Parent Type: `MatchLiveType`
      public struct Match: StratzAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchLiveType }
        public static var __selections: [ApolloAPI.Selection] {
          [
            .field("__typename", String.self),
            .field("radiantTeamId", Int?.self),
            .field("direTeamId", Int?.self),
            .field("gameMode", GraphQLEnum<StratzAPI.GameModeEnumType>?.self),
            .field("playbackData", PlaybackData?.self),
            .field("gameState", GraphQLEnum<StratzAPI.MatchLiveGameState>?.self),
            .field("players", [Player?]?.self),
            .field("liveWinRateValues", [LiveWinRateValue?]?.self),
          ]
        }

        public var radiantTeamId: Int? { __data["radiantTeamId"] }
        public var direTeamId: Int? { __data["direTeamId"] }
        public var gameMode: GraphQLEnum<StratzAPI.GameModeEnumType>? { __data["gameMode"] }
        public var playbackData: PlaybackData? { __data["playbackData"] }
        public var gameState: GraphQLEnum<StratzAPI.MatchLiveGameState>? { __data["gameState"] }
        public var players: [Player?]? { __data["players"] }
        public var liveWinRateValues: [LiveWinRateValue?]? { __data["liveWinRateValues"] }

        /// Live.Match.PlaybackData
        ///
        /// Parent Type: `MatchLivePlaybackDataType`
        public struct PlaybackData: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType {
            StratzAPI.Objects.MatchLivePlaybackDataType
          }
          public static var __selections: [ApolloAPI.Selection] {
            [
              .field("__typename", String.self),
              .field("roshanEvents", [RoshanEvent?]?.self),
              .field("buildingEvents", [BuildingEvent?]?.self),
              .field("pickBans", [PickBan?]?.self),
            ]
          }

          public var roshanEvents: [RoshanEvent?]? { __data["roshanEvents"] }
          public var buildingEvents: [BuildingEvent?]? { __data["buildingEvents"] }
          public var pickBans: [PickBan?]? { __data["pickBans"] }

          /// Live.Match.PlaybackData.RoshanEvent
          ///
          /// Parent Type: `MatchLiveRoshanDetailType`
          public struct RoshanEvent: StratzAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType {
              StratzAPI.Objects.MatchLiveRoshanDetailType
            }
            public static var __selections: [ApolloAPI.Selection] {
              [
                .field("__typename", String.self),
                .field("time", Int?.self),
                .field("isAlive", Bool?.self),
                .field("respawnTimer", Int?.self),
              ]
            }

            public var time: Int? { __data["time"] }
            public var isAlive: Bool? { __data["isAlive"] }
            public var respawnTimer: Int? { __data["respawnTimer"] }
          }

          /// Live.Match.PlaybackData.BuildingEvent
          ///
          /// Parent Type: `MatchLiveBuildingDetailType`
          public struct BuildingEvent: StratzAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType {
              StratzAPI.Objects.MatchLiveBuildingDetailType
            }
            public static var __selections: [ApolloAPI.Selection] {
              [
                .field("__typename", String.self),
                .field("time", Int.self),
                .field("indexId", Int?.self),
                .field("type", GraphQLEnum<StratzAPI.BuildingType>?.self),
                .field("isAlive", Bool.self),
                .field("positionX", Int?.self),
                .field("positionY", Int?.self),
                .field("isRadiant", Bool?.self),
                .field("npcId", Int?.self),
              ]
            }

            public var time: Int { __data["time"] }
            public var indexId: Int? { __data["indexId"] }
            public var type: GraphQLEnum<StratzAPI.BuildingType>? { __data["type"] }
            public var isAlive: Bool { __data["isAlive"] }
            public var positionX: Int? { __data["positionX"] }
            public var positionY: Int? { __data["positionY"] }
            public var isRadiant: Bool? { __data["isRadiant"] }
            public var npcId: Int? { __data["npcId"] }
          }

          /// Live.Match.PlaybackData.PickBan
          ///
          /// Parent Type: `MatchLivePickBanType`
          public struct PickBan: StratzAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType {
              StratzAPI.Objects.MatchLivePickBanType
            }
            public static var __selections: [ApolloAPI.Selection] {
              [
                .field("__typename", String.self),
                .field("isPick", Bool.self),
                .field("heroId", StratzAPI.Short?.self),
                .field("order", Int?.self),
                .field("bannedHeroId", StratzAPI.Short?.self),
                .field("isRadiant", Bool?.self),
              ]
            }

            public var isPick: Bool { __data["isPick"] }
            public var heroId: StratzAPI.Short? { __data["heroId"] }
            public var order: Int? { __data["order"] }
            public var bannedHeroId: StratzAPI.Short? { __data["bannedHeroId"] }
            public var isRadiant: Bool? { __data["isRadiant"] }
          }
        }

        /// Live.Match.Player
        ///
        /// Parent Type: `MatchLivePlayerType`
        public struct Player: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType {
            StratzAPI.Objects.MatchLivePlayerType
          }
          public static var __selections: [ApolloAPI.Selection] {
            [
              .field("__typename", String.self),
              .field("heroId", StratzAPI.Short?.self),
              .field("name", String?.self),
              .field("playerSlot", StratzAPI.Byte?.self),
              .field("isRadiant", Bool?.self),
              .field("playbackData", PlaybackData?.self),
            ]
          }

          public var heroId: StratzAPI.Short? { __data["heroId"] }
          public var name: String? { __data["name"] }
          public var playerSlot: StratzAPI.Byte? { __data["playerSlot"] }
          public var isRadiant: Bool? { __data["isRadiant"] }
          public var playbackData: PlaybackData? { __data["playbackData"] }

          /// Live.Match.Player.PlaybackData
          ///
          /// Parent Type: `MatchPlayerLivePlaybackDataType`
          public struct PlaybackData: StratzAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType {
              StratzAPI.Objects.MatchPlayerLivePlaybackDataType
            }
            public static var __selections: [ApolloAPI.Selection] {
              [
                .field("__typename", String.self),
                .field("killEvents", [KillEvent?]?.self),
                .field("deathEvents", [DeathEvent?]?.self),
                .field("positionEvents", [PositionEvent?]?.self),
                .field("inventoryEvents", [InventoryEvent?]?.self),
              ]
            }

            public var killEvents: [KillEvent?]? { __data["killEvents"] }
            public var deathEvents: [DeathEvent?]? { __data["deathEvents"] }
            public var positionEvents: [PositionEvent?]? { __data["positionEvents"] }
            public var inventoryEvents: [InventoryEvent?]? { __data["inventoryEvents"] }

            /// Live.Match.Player.PlaybackData.KillEvent
            ///
            /// Parent Type: `MatchLivePlayerKillDetailType`
            public struct KillEvent: StratzAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType {
                StratzAPI.Objects.MatchLivePlayerKillDetailType
              }
              public static var __selections: [ApolloAPI.Selection] {
                [
                  .field("__typename", String.self),
                  .field("time", Int.self),
                ]
              }

              public var time: Int { __data["time"] }
            }

            /// Live.Match.Player.PlaybackData.DeathEvent
            ///
            /// Parent Type: `MatchLivePlayerDeathDetailType`
            public struct DeathEvent: StratzAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType {
                StratzAPI.Objects.MatchLivePlayerDeathDetailType
              }
              public static var __selections: [ApolloAPI.Selection] {
                [
                  .field("__typename", String.self),
                  .field("time", Int.self),
                ]
              }

              public var time: Int { __data["time"] }
            }

            /// Live.Match.Player.PlaybackData.PositionEvent
            ///
            /// Parent Type: `MatchLivePlayerPositionDetailType`
            public struct PositionEvent: StratzAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType {
                StratzAPI.Objects.MatchLivePlayerPositionDetailType
              }
              public static var __selections: [ApolloAPI.Selection] {
                [
                  .field("__typename", String.self),
                  .field("time", Int.self),
                  .field("x", Int.self),
                  .field("y", Int.self),
                ]
              }

              public var time: Int { __data["time"] }
              public var x: Int { __data["x"] }
              public var y: Int { __data["y"] }
            }

            /// Live.Match.Player.PlaybackData.InventoryEvent
            ///
            /// Parent Type: `MatchLivePlayerInventoryDetailType`
            public struct InventoryEvent: StratzAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType {
                StratzAPI.Objects.MatchLivePlayerInventoryDetailType
              }
              public static var __selections: [ApolloAPI.Selection] {
                [
                  .field("__typename", String.self),
                  .field("time", Int.self),
                  .field("itemId0", StratzAPI.Short?.self),
                  .field("itemId1", StratzAPI.Short?.self),
                  .field("itemId2", StratzAPI.Short?.self),
                  .field("itemId3", StratzAPI.Short?.self),
                  .field("itemId4", StratzAPI.Short?.self),
                  .field("itemId5", StratzAPI.Short?.self),
                  .field("backpackId0", StratzAPI.Short?.self),
                  .field("backpackId1", StratzAPI.Short?.self),
                  .field("backpackId2", StratzAPI.Short?.self),
                ]
              }

              public var time: Int { __data["time"] }
              public var itemId0: StratzAPI.Short? { __data["itemId0"] }
              public var itemId1: StratzAPI.Short? { __data["itemId1"] }
              public var itemId2: StratzAPI.Short? { __data["itemId2"] }
              public var itemId3: StratzAPI.Short? { __data["itemId3"] }
              public var itemId4: StratzAPI.Short? { __data["itemId4"] }
              public var itemId5: StratzAPI.Short? { __data["itemId5"] }
              public var backpackId0: StratzAPI.Short? { __data["backpackId0"] }
              public var backpackId1: StratzAPI.Short? { __data["backpackId1"] }
              public var backpackId2: StratzAPI.Short? { __data["backpackId2"] }
            }
          }
        }

        /// Live.Match.LiveWinRateValue
        ///
        /// Parent Type: `MatchLiveWinRateDetailType`
        public struct LiveWinRateValue: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType {
            StratzAPI.Objects.MatchLiveWinRateDetailType
          }
          public static var __selections: [ApolloAPI.Selection] {
            [
              .field("__typename", String.self),
              .field("time", Int.self),
              .field("winRate", Double.self),
            ]
          }

          public var time: Int { __data["time"] }
          public var winRate: Double { __data["winRate"] }
        }
      }
    }
  }
}
