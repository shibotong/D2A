// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class HeroesQuery: GraphQLQuery {
  public static let operationName: String = "Heroes"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      #"""
      query Heroes($language: LanguageEnum) {
        constants {
          __typename
          heroes(language: $language) {
            __typename
            id
            abilities {
              __typename
              slot
              abilityId
            }
            roles {
              __typename
              roleId
              level
            }
            language {
              __typename
              displayName
              lore
              hype
            }
            talents {
              __typename
              abilityId
              slot
            }
          }
        }
      }
      """#
    ))

  public var language: GraphQLNullable<GraphQLEnum<LanguageEnum>>

  public init(language: GraphQLNullable<GraphQLEnum<LanguageEnum>>) {
    self.language = language
  }

  public var __variables: Variables? { ["language": language] }

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
        .field("heroes", [Hero?]?.self, arguments: ["language": .variable("language")]),
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
          .field("abilities", [Ability?]?.self),
          .field("roles", [Role?]?.self),
          .field("language", Language?.self),
          .field("talents", [Talent?]?.self),
        ] }

        public var id: StratzAPI.Short? { __data["id"] }
        public var abilities: [Ability?]? { __data["abilities"] }
        public var roles: [Role?]? { __data["roles"] }
        public var language: Language? { __data["language"] }
        public var talents: [Talent?]? { __data["talents"] }

        /// Constants.Hero.Ability
        ///
        /// Parent Type: `HeroAbilityType`
        public struct Ability: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.HeroAbilityType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("slot", StratzAPI.Byte.self),
            .field("abilityId", StratzAPI.Short.self),
          ] }

          public var slot: StratzAPI.Byte { __data["slot"] }
          public var abilityId: StratzAPI.Short { __data["abilityId"] }
        }

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

        /// Constants.Hero.Language
        ///
        /// Parent Type: `HeroLanguageType`
        public struct Language: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.HeroLanguageType }
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

        /// Constants.Hero.Talent
        ///
        /// Parent Type: `HeroTalentType`
        public struct Talent: StratzAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { StratzAPI.Objects.HeroTalentType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("abilityId", StratzAPI.Short?.self),
            .field("slot", StratzAPI.Byte?.self),
          ] }

          public var abilityId: StratzAPI.Short? { __data["abilityId"] }
          public var slot: StratzAPI.Byte? { __data["slot"] }
        }
      }
    }
  }
}
