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
    public static var __selections: [ApolloAPI.Selection] { [
      .field("live", Live?.self),
    ] }

    /// Queries used to find live match data.
    public var live: Live? { __data["live"] }

    /// Live
    ///
    /// Parent Type: `LiveQuery`
    public struct Live: StratzAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.LiveQuery }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("matches", [Match?]?.self, arguments: ["request": .variable("request")]),
      ] }

      /// Find all live matches. A live match is data where a match is on the Dota watch list and still active. All League games are also Live.
      public var matches: [Match?]? { __data["matches"] }

      /// Live.Match
      ///
      /// Parent Type: `MatchLiveType`
      public struct Match: StratzAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.MatchLiveType }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("matchId", StratzAPI.Long?.self),
        ] }

        public var matchId: StratzAPI.Long? { __data["matchId"] }
      }
    }
  }
}
