// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class HeroDataQuery: GraphQLQuery {
  public static let operationName: String = "HeroData"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      query HeroData {
        constants {
          __typename
          heroes {
            __typename
            id
            name
            roles {
              __typename
              roleId
              level
            }
            stats {
              __typename
              complexity
            }
          }
        }
      }
      """#
    ))

  public init() {}

  public struct Data: StratzAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.DotaQuery }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("constants", Constants?.self),
    ] }

    /// Queries used to query constants in Dota.
    public var constants: Constants? { __data["constants"] }

    /// Constants
    ///
    /// Parent Type: `ConstantQuery`
    public struct Constants: StratzAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.ConstantQuery }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("heroes", [Hero?]?.self),
      ] }

      public var heroes: [Hero?]? { __data["heroes"] }

      /// Constants.Hero
      ///
      /// Parent Type: `HeroType`
      public struct Hero: StratzAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.HeroType }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", StratzAPI.Short?.self),
          .field("name", String?.self),
          .field("roles", [Role?]?.self),
          .field("stats", Stats?.self),
        ] }

        public var id: StratzAPI.Short? { __data["id"] }
        public var name: String? { __data["name"] }
        public var roles: [Role?]? { __data["roles"] }
        public var stats: Stats? { __data["stats"] }

        /// Constants.Hero.Role
        ///
        /// Parent Type: `HeroRoleType`
        public struct Role: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.HeroRoleType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("roleId", GraphQLEnum<StratzAPI.HeroRoleEnum>?.self),
            .field("level", StratzAPI.Short?.self),
          ] }

          public var roleId: GraphQLEnum<StratzAPI.HeroRoleEnum>? { __data["roleId"] }
          public var level: StratzAPI.Short? { __data["level"] }
        }

        /// Constants.Hero.Stats
        ///
        /// Parent Type: `HeroStatType`
        public struct Stats: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.HeroStatType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("complexity", StratzAPI.Byte?.self),
          ] }

          public var complexity: StratzAPI.Byte? { __data["complexity"] }
        }
      }
    }
  }
}
