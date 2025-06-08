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
        let absoluteSeconds = abs(self)  // Convert to absolute value

        let minutes = absoluteSeconds / 60
        let remainingSeconds = absoluteSeconds % 60

        let sign = self >= 0 ? "" : "-"  // Determine the sign

        return "\(sign)\(minutes):\(String(format: "%02d", remainingSeconds))"
    }

    var toTime: LocalizedStringKey {
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

    var isDotaDayTime: Bool {
        let normalizedSeconds = self % 600  // Normalize the seconds within a 600-second cycle

        guard normalizedSeconds >= 0 && normalizedSeconds <= 300 else {
            return false  // Night time
        }
        return true  // Day time
    }

    private func getNumberOfUnit(_ diff: TimeInterval, _ interval: Double) -> Int {
        return Int(diff / interval)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
