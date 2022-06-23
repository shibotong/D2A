//
//  Extension.swift
//  App
//
//  Created by Shibo Tong on 17/6/2022.
//

import Foundation
import WidgetKit
import SwiftUI

extension WidgetFamily: EnvironmentKey {
    public static var defaultValue: WidgetFamily = .systemMedium
}

extension EnvironmentValues {
  var widgetFamily: WidgetFamily {
    get { self[WidgetFamily.self] }
    set { self[WidgetFamily.self] = newValue }
  }
}
