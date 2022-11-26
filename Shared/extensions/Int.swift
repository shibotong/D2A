//
//  Int.swift
//  App
//
//  Created by Shibo Tong on 12/8/21.
//

import Foundation
import SwiftUI

extension Int {
    var toDuration: String {
        var min = self / 60
        let sec = self - min * 60
        if min >= 60 {
            let hr = min / 60
            min = min - hr * 60
            if min < 10 && sec < 10{
                return "\(hr):0\(min):0\(sec)"
            } else if min < 10 {
                return "\(hr):0\(min):\(sec)"
            } else if sec < 10 {
                return "\(hr):\(min):0\(sec)"
            } else {
                return "\(hr):\(min):\(sec)"
            }
        } else {
            if sec < 10 {
                return "\(min):0\(sec)"
            } else {
                return "\(min):\(sec)"
            }
        }
    }
    
    var toTime: LocalizedStringKey {
        let date = TimeInterval(self)
//        if Calendar.current.isDateInToday(date) {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "HH:mm"
//            return formatter.string(from: date)
//        } else if Calendar.current.isDateInYesterday(date){
//            return "Yesterday"
//        } else {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy. MM. dd"
//            return formatter.string(from: date)
//        }
        let today = Date().timeIntervalSince1970
        let oneHour = 3600.0
        let oneDay = 86400.0
        let oneMonth = 2592000.0
        let oneYear = 31536000.0
        let diff = today - date
        if diff < oneHour {
            // within one hour return minues
            return "MINUTESCALCULATE \(getNumberOfUnit(diff, 60.0))"
        } else if diff < oneDay {
            // within one day return hours
            return "HOURSCALCULATE \(getNumberOfUnit(diff, oneHour))"
        } else if diff < oneMonth {
            // within one month return days
            return "DAYSCALCULATE \(getNumberOfUnit(diff, oneDay))"
        } else if diff < oneYear {
            return "MONTHSCALCULATE \(getNumberOfUnit(diff, oneMonth))"
        } else {
            return "YEARSCALCULATE \(getNumberOfUnit(diff, oneYear))"
        }
    }
    
    private func getNumberOfUnit(_ diff: TimeInterval, _ interval: Double) -> Int {
        return Int(diff/interval)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
