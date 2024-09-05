//
//  SwiftDataPerisistenceController.swift
//  D2A
//
//  Created by Shibo Tong on 1/9/2024.
//

import Foundation
import SwiftData

@available(iOS 17, *)
class SwiftDataPerisistenceController {
    
    let container: ModelContainer
    
    static let shared = SwiftDataPerisistenceController()
    
    static let preview = SwiftDataPerisistenceController(configuration: .init(isStoredInMemoryOnly: true))
    
    init(configuration: ModelConfiguration = .init(isStoredInMemoryOnly: false)) {
        do {
            container = try ModelContainer(for: HeroV2.self, HeroV2Localisation.self, RoleV2.self, AbilityV2.self, AbilityV2Attribute.self, AbilityV2Localisation.self, configurations: configuration)
        } catch {
            fatalError("Create container failed")
        }
    }
}
