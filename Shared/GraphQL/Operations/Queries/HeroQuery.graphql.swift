// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension D2A {
  class HeroQuery: GraphQLQuery {
    public static let operationName: String = "Hero"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query Hero($id: Short!) {
          constants {
            __typename
            hero(id: $id) {
              __typename
              id
              name
              displayName
              shortName
              aliases
              roles {
                __typename
                roleId
                level
              }
              talents {
                __typename
                abilityId
                slot
              }
              stats {
                __typename
                visionDaytimeRange
                visionNighttimeRange
                complexity
              }
            }
          }
        }
        """#
      ))

    public var id: Short

    public init(id: Short) {
      self.id = id
    }

    public var __variables: Variables? { ["id": id] }

    public struct Data: D2A.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { D2A.Objects.DotaQuery }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("constants", Constants?.self),
      ] }

      /// Queries used to query constants in Dota.
      public var constants: Constants? { __data["constants"] }

      /// Constants
      ///
      /// Parent Type: `ConstantQuery`
      public struct Constants: D2A.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { D2A.Objects.ConstantQuery }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("hero", Hero?.self, arguments: ["id": .variable("id")]),
        ] }

        public var hero: Hero? { __data["hero"] }

        /// Constants.Hero
        ///
        /// Parent Type: `HeroType`
        public struct Hero: D2A.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { D2A.Objects.HeroType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", D2A.Short?.self),
            .field("name", String?.self),
            .field("displayName", String?.self),
            .field("shortName", String?.self),
            .field("aliases", [String?]?.self),
            .field("roles", [Role?]?.self),
            .field("talents", [Talent?]?.self),
            .field("stats", Stats?.self),
          ] }

          public var id: D2A.Short? { __data["id"] }
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
          public struct Role: D2A.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { D2A.Objects.HeroRoleType }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("roleId", GraphQLEnum<D2A.HeroRoleEnum>?.self),
              .field("level", D2A.Short?.self),
            ] }

            public var roleId: GraphQLEnum<D2A.HeroRoleEnum>? { __data["roleId"] }
            public var level: D2A.Short? { __data["level"] }
          }

          /// Constants.Hero.Talent
          ///
          /// Parent Type: `HeroTalentType`
          public struct Talent: D2A.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { D2A.Objects.HeroTalentType }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("abilityId", D2A.Short?.self),
              .field("slot", D2A.Byte?.self),
            ] }

            public var abilityId: D2A.Short? { __data["abilityId"] }
            public var slot: D2A.Byte? { __data["slot"] }
          }

          /// Constants.Hero.Stats
          ///
          /// Parent Type: `HeroStatType`
          public struct Stats: D2A.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { D2A.Objects.HeroStatType }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("visionDaytimeRange", Double?.self),
              .field("visionNighttimeRange", Double?.self),
              .field("complexity", D2A.Byte?.self),
            ] }

            public var visionDaytimeRange: Double? { __data["visionDaytimeRange"] }
            public var visionNighttimeRange: Double? { __data["visionNighttimeRange"] }
            public var complexity: D2A.Byte? { __data["complexity"] }
          }
        }
      }
    }
  }

}