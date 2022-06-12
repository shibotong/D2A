//
//  DateValue.swift
//  App
//
//  Created by Shibo Tong on 12/6/2022.
//

import Foundation

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
