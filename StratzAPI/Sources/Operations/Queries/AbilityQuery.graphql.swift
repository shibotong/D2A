// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AbilityQuery: GraphQLQuery {
  public static let operationName: String = "Ability"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Ability($language: Language) { constants { __typename abilities(language: $language) { __typename id name language { __typename displayName description attributes lore aghanimDescription shardDescription notes } attributes { __typename name value } } } }"#
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
        .field("abilities", [Ability?]?.self, arguments: ["language": .variable("language")]),
      ] }

      /// Find ability details.
      public var abilities: [Ability?]? { __data["abilities"] }

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
