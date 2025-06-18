//
//  OnChange.swift
//  D2A
//
//  Created by Shibo Tong on 18/6/2025.
//

import Foundation
import SwiftUI

extension View {
    func onChange<V: Equatable>(of value: V,
                                action: @escaping (_ newValue: V) -> Void) -> some View {
        if #available(iOS 17.0, *) {
            return onChange(of: value) { oldValue, newValue in
                guard oldValue != newValue else {
                    return
                }
                action(newValue)
            }
        } else {
            return onChange(of: value, perform: action)
        }
    }
}
