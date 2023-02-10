//
//  ProductSubView.swift
//  App
//
//  Created by Shibo Tong on 19/9/21.
//

import SwiftUI
import StoreKit

struct ProductSubView: View {
    var product: SKProduct
    var monthlyProduct: SKProduct
    @Environment(\.colorScheme) var color
    @Binding var selectedProduct: SKProduct?
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.secondarySystemBackground))
            RoundedRectangle(cornerRadius: 10).stroke(Color.primaryDota, lineWidth: selectedProduct == product ? 3 : 0)
            VStack {
                savingView()
                    .offset(y: -10)
                    .padding(.bottom, -10)
                buildMainView().padding(.bottom)
            }
        }
        .onTapGesture {
            selectedProduct = product
        }
    }
    @ViewBuilder private func buildMainView() -> some View {
        VStack {
            Text("\(product.getNumberOfUnit()) month\(product.getNumberOfUnit() > 1 ? "s" : "")").font(.system(size: 15))
            Text(product.localizedPrice ?? "").font(.system(size: 15)).bold()
            Text("\(product.monthlyCost!) / mo").font(.system(size: 12))
        }
    }
    
    @ViewBuilder private func savingView() -> some View {
        if calculateSave() == 0 {
            Capsule().foregroundColor(.clear).frame(height: 20)
        } else {
            ZStack {
                Capsule().foregroundColor(.primaryDota)
                Text("SAVE \(buildSaveString())").font(.system(size: 10)).bold().foregroundColor(.white)
            }.frame(height: 20)
        }
    }
    
    private func calculateSave() -> Int {
        return Int(Double(1.0 - (product.monthlyPrice / monthlyProduct.price.doubleValue)) * 100)
    }
    
    private func buildSaveString() -> String {
        return "\(calculateSave())%"
    }
    
    private func getColor() -> Color {
        if product.subscriptionPeriod!.unit == .year {
            return .primaryDota
        } else {
            if product.subscriptionPeriod!.numberOfUnits > 1 {
                return Color(.systemBlue)
            } else {
                return Color(.systemGreen)
            }
        }
    }
    
    private func getUnit() -> String {
        switch product.subscriptionPeriod!.unit {
        case .day:
            return "day"
        case .month:
            return "month"
        case .week:
            return "week"
        case .year:
            return "year"
        @unknown default:
            return ""
        }
    }
}

// struct ProductSubView_Previews: PreviewProvider {
//    @State static var product: SKProduct? = MockSKProduct()
//    static var previews: some View {
//        ProductSubView(product: MockSKProduct(), monthlyProduct: MockSKProduct(), selectedProduct: $product)
//            .previewLayout(.fixed(width: 100, height: 150))
//    }
// }

class MockSKProductSubscriptionPeriod: SKProductSubscriptionPeriod {
    private let _numberOfUnits: Int
    private let _unit: SKProduct.PeriodUnit

    init(numberOfUnits: Int = 1, unit: SKProduct.PeriodUnit = .year) {
        _numberOfUnits = numberOfUnits
        _unit = unit
    }

    override var numberOfUnits: Int {
        _numberOfUnits
    }

    override var unit: SKProduct.PeriodUnit {
        _unit
    }
}

class MockSKProduct: SKProduct {
    private var _subscriptionPeriod: SKProductSubscriptionPeriod

    init(subscriptionPeriod: SKProductSubscriptionPeriod = MockSKProductSubscriptionPeriod()) {
        _subscriptionPeriod = subscriptionPeriod
    }

    override var subscriptionPeriod: SKProductSubscriptionPeriod? {
        get {
            _subscriptionPeriod
        }
    }
}
