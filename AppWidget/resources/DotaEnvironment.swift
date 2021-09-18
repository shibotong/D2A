//
//  DotaEnvironment.swift
//  AppWidgetExtension
//
//  Created by Shibo Tong on 18/9/21.
//

import Foundation
import SwiftUI

class DotaEnvironment {
    
    static var shared = DotaEnvironment()
    
    @AppStorage("dotaArmory.userID") var userIDs: [String]
    
    init() {
        
    }
}
