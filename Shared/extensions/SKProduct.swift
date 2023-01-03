//
//  SKProduct.swift
//  App
//
//  Created by Shibo Tong on 16/9/21.
//

import Foundation
import StoreKit

extension SKProduct {

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    var isFree: Bool {
        price == 0.00
    }

    var localizedPrice: String? {
        guard !isFree else {
            return nil
        }
        
        let formatter = SKProduct.formatter
        formatter.locale = priceLocale

        return formatter.string(from: price)
    }
    
    var monthlyCost: String? {
        let cost = price
        var months = subscriptionPeriod!.numberOfUnits
        if subscriptionPeriod!.unit == .year {
            months = months * 12
        }
        let monthlyCost = (cost as Decimal / Decimal(months)) as NSNumber
        
        let formatter =  SKProduct.formatter
        formatter.locale = priceLocale
        
        return formatter.string(from: monthlyCost)
    }
    
    var monthlyPrice: Double {
        let cost = price.doubleValue
        var months = subscriptionPeriod!.numberOfUnits
        if subscriptionPeriod!.unit == .year {
            months = months * 12
        }
        let monthlyCost = cost / Double(months)
        return monthlyCost
    }

    func getNumberOfUnit() -> Int {
        let number = subscriptionPeriod!.numberOfUnits
        switch subscriptionPeriod!.unit {
        case .month:
            return number
        case .year:
            return number * 12
        default:
            return 0
        }
    }
}
