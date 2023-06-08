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
      ] }

      public var matchId: StratzAPI.Long? { __data["matchId"] }
      public var radiantScore: StratzAPI.Byte? { __data["radiantScore"] }
      public var direScore: StratzAPI.Byte? { __data["direScore"] }
    }
  }
}
