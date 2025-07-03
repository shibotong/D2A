//
//  D2ANotificationCenter.swift
//  D2A
//
//  Created by Shibo Tong on 3/7/2025.
//

import Combine
import Foundation

class D2ANotificationCenter: NotificationCenter, @unchecked Sendable {
    static let shared = D2ANotificationCenter()
    
    let stratzToken = PassthroughSubject<String, Never>()
}
