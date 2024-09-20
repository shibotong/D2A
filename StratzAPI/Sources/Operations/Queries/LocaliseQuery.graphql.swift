// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LocaliseQuery: GraphQLQuery {
  public static let operationName: String = "Localise"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Localise($language: Language) { constants { __typename heroes(language: $language) { __typename id language { __typename displayName lore hype } roles { __typename roleId level } talents { __typename abilityId slot } stats { __typename visionDaytimeRange visionNighttimeRange complexity } } abilities(language: $language) { __typename id name language { __typename displayName description attributes lore aghanimDescription shardDescription notes } attributes { __typename name value } } } }"#
    ))

  public var language: GraphQLNullable<GraphQLEnum<Language>>

  public init(language: GraphQLNullable<GraphQLEnum<Language>>) {
    self.language = language
  }

  public var __variables: Variables? { ["language": language] }

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
        .field("heroes", [Hero?]?.self, arguments: ["language": .variable("language")]),
        .field("abilities", [Ability?]?.self, arguments: ["language": .variable("language")]),
      ] }

      public var heroes: [Hero?]? { __data["heroes"] }
      /// Find ability details.
      public var abilities: [Ability?]? { __data["abilities"] }

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
          .field("language", Language?.self),
          .field("roles", [Role?]?.self),
          .field("talents", [Talent?]?.self),
          .field("stats", Stats?.self),
        ] }

        public var id: StratzAPI.Short? { __data["id"] }
        public var language: Language? { __data["language"] }
        public var roles: [Role?]? { __data["roles"] }
        public var talents: [Talent?]? { __data["talents"] }
        public var stats: Stats? { __data["stats"] }

        /// Constants.Hero.Language
        ///
        /// Parent Type: `HeroLanguageType`
        public struct Language: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { StratzAPI.Objects.HeroLanguageType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("displayName", String?.self),
            .field("lore", String?.self),
            .field("hype", String?.self),
          ] }

          public var displayName: String? { __data["displayName"] }
          public var lore: String? { __data["lore"] }
          public var hype: String? { __data["hype"] }
        }

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

      /// Constants.Ability
      ///
      /// Parent Type: `AbilityType`
      public struct Ability: StratzAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { StratzAPI.Objects.AbilityType }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", StratzAPI.Short?.self),
          .field("name", String?.self),
          .field("language", Language?.self),
          .field("attributes", [Attribute?]?.self),
        ] }

        public var id: StratzAPI.Short? { __data["id"] }
        public var name: String? { __data["name"] }
        public var language: Language? { __data["language"] }
        public var attributes: [Attribute?]? { __data["attributes"] }

        /// Constants.Ability.Language
        ///
        /// Parent Type: `AbilityLanguageType`
        public struct Language: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { StratzAPI.Objects.AbilityLanguageType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("displayName", String?.self),
            .field("description", [String?]?.self),
            .field("attributes", [String?]?.self),
            .field("lore", String?.self),
            .field("aghanimDescription", String?.self),
            .field("shardDescription", String?.self),
            .field("notes", [String?]?.self),
          ] }

          public var displayName: String? { __data["displayName"] }
          public var description: [String?]? { __data["description"] }
          public var attributes: [String?]? { __data["attributes"] }
          public var lore: String? { __data["lore"] }
          public var aghanimDescription: String? { __data["aghanimDescription"] }
          public var shardDescription: String? { __data["shardDescription"] }
          public var notes: [String?]? { __data["notes"] }
        }

        /// Constants.Ability.Attribute
        ///
        /// Parent Type: `AbilityAttributeType`
        public struct Attribute: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { StratzAPI.Objects.AbilityAttributeType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String?.self),
            .field("value", String?.self),
          ] }

          public var name: String? { __data["name"] }
          public var value: String? { __data["value"] }
        }
      }
    }
  }
}
