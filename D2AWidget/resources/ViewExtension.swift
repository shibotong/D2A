//
//  ViewExtension.swift
//  D2A
//
//  Created by Shibo Tong on 24/1/2024.
//

import SwiftUI

extension View {

    // swift-format-ignore: UseEarlyExits
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOS 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
