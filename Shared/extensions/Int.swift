//
//  Int.swift
//  App
//
//  Created by Shibo Tong on 12/8/21.
//

import Foundation
import SwiftUI

extension Int {
    func convertToDuration() -> String {
        var absolute = self
        var minus = false
        if self < 0 {
            absolute = self * -1
            minus = true
        }
        
        var min = absolute / 60
        let sec = absolute - min * 60
        if min >= 60 {
            let hr = min / 60
            min = min - hr * 60
            if min < 10 && sec < 10{
                return "\(minus ? "-" : "")\(hr):0\(min):0\(sec)"
            } else if min < 10 {
                return "\(minus ? "-" : "")\(hr):0\(min):\(sec)"
            } else if sec < 10 {
                return "\(minus ? "-" : "")\(hr):\(min):0\(sec)"
            } else {
                return "\(minus ? "-" : "")\(hr):\(min):\(sec)"
            }
        } else {
            if sec < 10 {
                return "\(minus ? "-" : "")\(min):0\(sec)"
            } else {
                return "\(minus ? "-" : "")\(min):\(sec)"
            }
        }
    }
    
    func convertToTime() -> LocalizedStringKey {
        let date = TimeInterval(self)
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
