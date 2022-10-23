//
//  BuildingType.swift
//  D2A
//
//  Created by Shibo Tong on 23/10/2022.
//

import Foundation

extension BuildingType {
    var scale: CGFloat {
        switch self {
        case .fort:
            return 25
        case .tower:
            return 30
        case .barracks:
            return 40
        case .healer:
            return 30
        case .outpost:
            return 30
        case .__unknown(_):
            return 30
        }
    }
}
