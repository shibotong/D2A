//
//  ViewExtension.swift
//  D2A
//
//  Created by Shibo Tong on 24/1/2024.
//

import SwiftUI

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        guard #available(iOS 17.0, *) else {
            return background(backgroundView)
        }
        return containerBackground(for: .widget) {
            backgroundView
        }
    }
}
