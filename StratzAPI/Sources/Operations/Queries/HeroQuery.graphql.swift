// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class HeroQuery: GraphQLQuery {
  public static let operationName: String = "Hero"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Hero($id: Short!, $language: Language!) { constants { __typename hero(id: $id, language: $language) { __typename id name displayName shortName aliases roles { __typename roleId level } talents { __typename abilityId slot } stats { __typename visionDaytimeRange visionNighttimeRange complexity } } } }"#
    ))

  public var id: Short
  public var language: GraphQLEnum<Language>

  public init(
    id: Short,
    language: GraphQLEnum<Language>
  ) {
    self.id = id
    self.language = language
  }

  public var __variables: Variables? { [
    "id": id,
    "language": language
  ] }

  public struct Data: StratzAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { StratzAPI.Objects.DotaQuery }
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

      public static var __parentType: any ApolloAPI.ParentType { StratzAPI.Objects.ConstantQuery }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("hero", Hero?.self, arguments: [
          "id": .variable("id"),
          "language": .variable("language")
        ]),
      ] }

      public var hero: Hero? { __data["hero"] }

      /// Constants.Hero
      ///
      /// Parent Type: `HeroType`
      public struct Hero: StratzAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { StratzAPI.Objects.HeroType }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", StratzAPI.Short?.self),
          .field("name", String?.self),
          .field("displayName", String?.self),
          .field("shortName", String?.self),
          .field("aliases", [String?]?.self),
          .field("roles", [Role?]?.self),
          .field("talents", [Talent?]?.self),
          .field("stats", Stats?.self),
        ] }

        public var id: StratzAPI.Short? { __data["id"] }
        public var name: String? { __data["name"] }
        public var displayName: String? { __data["displayName"] }
        public var shortName: String? { __data["shortName"] }
        public var aliases: [String?]? { __data["aliases"] }
        public var roles: [Role?]? { __data["roles"] }
        public var talents: [Talent?]? { __data["talents"] }
        public var stats: Stats? { __data["stats"] }

        /// Constants.Hero.Role
        ///
        /// Parent Type: `HeroRoleType`
        public struct Role: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { StratzAPI.Objects.HeroRoleType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("roleId", GraphQLEnum<StratzAPI.HeroRoleEnum>?.self),
            .field("level", StratzAPI.Short?.self),
          ] }

          public var roleId: GraphQLEnum<StratzAPI.HeroRoleEnum>? { __data["roleId"] }
          public var level: StratzAPI.Short? { __data["level"] }
        }

        /// Constants.Hero.Talent
        ///
        /// Parent Type: `HeroTalentType`
        public struct Talent: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { StratzAPI.Objects.HeroTalentType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("abilityId", StratzAPI.Short?.self),
            .field("slot", StratzAPI.Byte?.self),
          ] }

          public var abilityId: StratzAPI.Short? { __data["abilityId"] }
          public var slot: StratzAPI.Byte? { __data["slot"] }
        }

        /// Constants.Hero.Stats
        ///
        /// Parent Type: `HeroStatType`
        public struct Stats: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { StratzAPI.Objects.HeroStatType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("visionDaytimeRange", Double?.self),
            .field("visionNighttimeRange", Double?.self),
            .field("complexity", StratzAPI.Byte?.self),
          ] }

          public var visionDaytimeRange: Double? { __data["visionDaytimeRange"] }
          public var visionNighttimeRange: Double? { __data["visionNighttimeRange"] }
          public var complexity: StratzAPI.Byte? { __data["complexity"] }
        }
      }
    }
  }
}
