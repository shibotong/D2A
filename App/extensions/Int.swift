//
//  Int.swift
//  App
//
//  Created by Shibo Tong on 12/8/21.
//

import Foundation

extension Int {
    func convertToDuration() -> String {
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
    
    func convertToTime() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        if Calendar.current.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        } else if Calendar.current.isDateInYesterday(date){
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy. MM. dd"
            return formatter.string(from: date)
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
