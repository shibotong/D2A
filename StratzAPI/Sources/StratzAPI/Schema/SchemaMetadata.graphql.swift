// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == StratzAPI.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == StratzAPI.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == StratzAPI.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == StratzAPI.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> Object? {
    switch typename {
    case "DotaQuery": return StratzAPI.Objects.DotaQuery
    case "ConstantQuery": return StratzAPI.Objects.ConstantQuery
    case "HeroType": return StratzAPI.Objects.HeroType
    case "HeroRoleType": return StratzAPI.Objects.HeroRoleType
    case "HeroTalentType": return StratzAPI.Objects.HeroTalentType
    case "HeroStatType": return StratzAPI.Objects.HeroStatType
    case "AbilityType": return StratzAPI.Objects.AbilityType
    case "AbilityLanguageType": return StratzAPI.Objects.AbilityLanguageType
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}