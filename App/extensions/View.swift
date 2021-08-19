//
//  View.swift
//  App
//
//  Created by Shibo Tong on 16/8/21.
//

import SwiftUI

extension View {
    public func currentDeviceNavigationViewStyle() -> AnyView {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return AnyView(self.navigationViewStyle(DefaultNavigationViewStyle()))
        } else {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//        
//        var standardAppearance = UINavigationBarAppearance()
////        standardAppearance.configureWithTransparentBackground()
//        var scrollAppearance = UINavigationBarAppearance()
//        scrollAppearance.configureWithTransparentBackground()
//        var compactAppearacne = UINavigationBarAppearance()
////        compactAppearacne.configureWithTransparentBackground()
//        
//        navigationBar.standardAppearance = standardAppearance
//        navigationBar.scrollEdgeAppearance = scrollAppearance
//        navigationBar.compactAppearance = compactAppearacne
//    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

