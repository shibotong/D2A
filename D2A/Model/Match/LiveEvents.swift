//
//  LiveEvents.swift
//  D2A
//
//  Created by Shibo Tong on 23/10/2022.
//

import Foundation

protocol LiveEvent {
    var id: UUID { get }
    var time: Int { get }
}

struct Event {
    var time: Int
    var events: [LiveEvent]
}

struct KillEvent: LiveEvent {
    var id = UUID()
    var time: Int
    var kill: [Int]
    var died: [Int]
}

struct PurchaseEvent: LiveEvent {
    var id = UUID()
    var time: Int
    var hero: Int
    var item: Int
}
