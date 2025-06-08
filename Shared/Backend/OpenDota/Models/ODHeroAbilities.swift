//
//  ODHeroAbilities.swift
//  D2A
//
//  Created by Shibo Tong on 4/5/2025.
//

class ODHeroAbilities: Decodable {
  var abilities: [String]
  var talents: [ODTalent]
  var facets: [Facet]

  struct ODTalent: Decodable {
    var name: String
    var level: Int
  }

  struct Facet: Decodable {
    var id: Int
    var name: String
    var icon: String
    var color: String
    var gradientID: Int
    var title: String
    var description: String

    enum CodingKeys: String, CodingKey {
      case id
      case name
      case icon
      case color
      case gradientID = "gradient_id"
      case title
      case description
    }
  }
}
