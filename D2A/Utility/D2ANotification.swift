//
//  D2ANotification.swift
//  D2A
//
//  Created by Shibo Tong on 3/4/2026.
//

import Combine

class D2ANotification {
    static let `default` = D2ANotification()
    
    let syncingCompletion = PassthroughSubject<Bool, Never>()
}
