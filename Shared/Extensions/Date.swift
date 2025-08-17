//
//  Animation.swift
//  App
//
//  Created by Shibo Tong on 15/8/21.
//

import Foundation
import SwiftUI

extension Date {
    init?(utc: String) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = formatter.date(from: utc) else { return nil }
        self = date
    }
    
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
    
    func addComponent(year: Int = 0, month: Int = 0, day: Int = 0, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date! {
        var dateComponent = DateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = day
        dateComponent.hour = hour
        dateComponent.minute = minute
        dateComponent.second = second
        return Calendar.current.date(byAdding: dateComponent, to: self)
    }
}
