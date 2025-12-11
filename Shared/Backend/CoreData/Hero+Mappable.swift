//
//  Hero+Mappable.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2025.
//

import CoreData

extension Hero: Mappable {
    func map(_ json: [String: Any]) {
        if let id = json["id"] as? Int {
            setIfNotEqual(self, keyPath: \.id, value: <#T##Equatable#>)
        }
    }
}
