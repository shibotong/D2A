// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LiveMatchListQuery: GraphQLQuery {
    public static let operationName: String = "LiveMatchListQuery"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
        definition: .init(
            #"""
            query LiveMatchListQuery($request: MatchLiveRequestType) {
              live {
                __typename
                matches(request: $request) {
                  __typename
                  matchId
                  radiantScore
                  direScore
                  leagueId
                  league {
                    __typename
                    id
                    displayName
                  }
                  averageRank
                  gameTime
                  radiantTeamId
                  direTeamId
                  players {
                    __typename
                    heroId
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
                  }
                }
              }
            }
            """#
        ))

    public var request: GraphQLNullable<MatchLiveRequestType>

    public init(request: GraphQLNullable<MatchLiveRequestType>) {
        self.request = request
    }

    public var __variables: Variables? { ["request": request] }

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
                    .field("matches", [Match?]?.self, arguments: ["request": .variable("request")]),
                ]
            }

            /// Find all live matches. A live match is data where a match is on the Dota watch list and still active. All League games are also Live.
            public var matches: [Match?]? { __data["matches"] }

            /// Live.Match
            ///
            /// Parent Type: `MatchLiveType`
            public struct Match: StratzAPI.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: ApolloAPI.ParentType {
                    StratzAPI.Objects.MatchLiveType
                }
                public static var __selections: [ApolloAPI.Selection] {
                    [
                        .field("__typename", String.self),
                        .field("matchId", StratzAPI.Long?.self),
                        .field("radiantScore", StratzAPI.Byte?.self),
                        .field("direScore", StratzAPI.Byte?.self),
                        .field("leagueId", Int?.self),
                        .field("league", League?.self),
                        .field("averageRank", Int?.self),
                        .field("gameTime", Int?.self),
                        .field("radiantTeamId", Int?.self),
                        .field("direTeamId", Int?.self),
                        .field("players", [Player?]?.self),
                    ]
                }

                public var matchId: StratzAPI.Long? { __data["matchId"] }
                public var radiantScore: StratzAPI.Byte? { __data["radiantScore"] }
                public var direScore: StratzAPI.Byte? { __data["direScore"] }
                public var leagueId: Int? { __data["leagueId"] }
                public var league: League? { __data["league"] }
                public var averageRank: Int? { __data["averageRank"] }
                public var gameTime: Int? { __data["gameTime"] }
                public var radiantTeamId: Int? { __data["radiantTeamId"] }
                public var direTeamId: Int? { __data["direTeamId"] }
                public var players: [Player?]? { __data["players"] }

                /// Live.Match.League
                ///
                /// Parent Type: `LeagueType`
                public struct League: StratzAPI.SelectionSet {
                    public let __data: DataDict
                    public init(_dataDict: DataDict) { __data = _dataDict }

                    public static var __parentType: ApolloAPI.ParentType {
                        StratzAPI.Objects.LeagueType
                    }
                    public static var __selections: [ApolloAPI.Selection] {
                        [
                            .field("__typename", String.self),
                            .field("id", Int?.self),
                            .field("displayName", String?.self),
                        ]
                    }

                    public var id: Int? { __data["id"] }
                    public var displayName: String? { __data["displayName"] }
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
                            .field("steamAccountId", StratzAPI.Long?.self),
                            .field("steamAccount", SteamAccount?.self),
                            .field("playerSlot", StratzAPI.Byte?.self),
                            .field("isRadiant", Bool?.self),
                        ]
                    }

                    public var heroId: StratzAPI.Short? { __data["heroId"] }
                    public var steamAccountId: StratzAPI.Long? { __data["steamAccountId"] }
                    public var steamAccount: SteamAccount? { __data["steamAccount"] }
                    public var playerSlot: StratzAPI.Byte? { __data["playerSlot"] }
                    public var isRadiant: Bool? { __data["isRadiant"] }

                    /// Live.Match.Player.SteamAccount
                    ///
                    /// Parent Type: `SteamAccountType`
                    public struct SteamAccount: StratzAPI.SelectionSet {
                        public let __data: DataDict
                        public init(_dataDict: DataDict) { __data = _dataDict }

                        public static var __parentType: ApolloAPI.ParentType {
                            StratzAPI.Objects.SteamAccountType
                        }
                        public static var __selections: [ApolloAPI.Selection] {
                            [
                                .field("__typename", String.self),
                                .field("name", String?.self),
                                .field("realName", String?.self),
                                .field("avatar", String?.self),
                                .field("rankShift", StratzAPI.Short?.self),
                                .field("seasonRank", StratzAPI.Byte?.self),
                                .field("proSteamAccount", ProSteamAccount?.self),
                            ]
                        }

                        public var name: String? { __data["name"] }
                        public var realName: String? { __data["realName"] }
                        public var avatar: String? { __data["avatar"] }
                        public var rankShift: StratzAPI.Short? { __data["rankShift"] }
                        public var seasonRank: StratzAPI.Byte? { __data["seasonRank"] }
                        public var proSteamAccount: ProSteamAccount? { __data["proSteamAccount"] }

                        /// Live.Match.Player.SteamAccount.ProSteamAccount
                        ///
                        /// Parent Type: `ProSteamAccountType`
                        public struct ProSteamAccount: StratzAPI.SelectionSet {
                            public let __data: DataDict
                            public init(_dataDict: DataDict) { __data = _dataDict }

                            public static var __parentType: ApolloAPI.ParentType {
                                StratzAPI.Objects.ProSteamAccountType
                            }
                            public static var __selections: [ApolloAPI.Selection] {
                                [
                                    .field("__typename", String.self),
                                    .field("name", String?.self),
                                    .field("realName", String?.self),
                                ]
                            }

                            public var name: String? { __data["name"] }
                            public var realName: String? { __data["realName"] }
                        }
                    }
                }
            }
        }
    }
}
