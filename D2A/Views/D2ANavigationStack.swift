//
//  D2ANavigationStack.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

import SwiftUI

struct D2ANavigationStack<Content: View>: View {

    let content: () -> Content

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content()
            }
        } else {
            NavigationView {
                content()
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct D2ANavigationSplitView<SideBar: View, Content: View>: View {
    let sideBar: () -> SideBar
    let detail: () -> Content

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationSplitView(sidebar: sideBar) {
                NavigationStack {
                    detail()
                }
            }
        } else {
            NavigationView {
                sideBar()
                detail()
            }
            .navigationViewStyle(.columns)
        }
    }

}
