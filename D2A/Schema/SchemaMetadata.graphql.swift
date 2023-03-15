// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol D2A_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == D2A.SchemaMetadata {}

public protocol D2A_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == D2A.SchemaMetadata {}

public protocol D2A_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == D2A.SchemaMetadata {}

public protocol D2A_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == D2A.SchemaMetadata {}

public extension D2A {
  typealias ID = String

  typealias SelectionSet = D2A_SelectionSet

  typealias InlineFragment = D2A_InlineFragment

  typealias MutableSelectionSet = D2A_MutableSelectionSet

  typealias MutableInlineFragment = D2A_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    public static func objectType(forTypename typename: String) -> Object? {
      switch typename {
      case "DotaQuery": return D2A.Objects.DotaQuery
      case "ConstantQuery": return D2A.Objects.ConstantQuery
      case "HeroType": return D2A.Objects.HeroType
      case "HeroRoleType": return D2A.Objects.HeroRoleType
      case "HeroTalentType": return D2A.Objects.HeroTalentType
      case "HeroStatType": return D2A.Objects.HeroStatType
      case "AbilityType": return D2A.Objects.AbilityType
      case "AbilityLanguageType": return D2A.Objects.AbilityLanguageType
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}