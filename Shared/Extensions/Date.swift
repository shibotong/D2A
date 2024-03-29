//
//  Animation.swift
//  App
//
//  Created by Shibo Tong on 15/8/21.
//

import Foundation
import SwiftUI

extension Date {
    var startOfDay: Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
    
    var toTime: LocalizedStringKey {
        let timeInterval = Int(timeIntervalSince1970)
        return timeInterval.toTime
    }
    
    var isToday: Bool {
        return self.startOfDay == Date().startOfDay
    }
}
