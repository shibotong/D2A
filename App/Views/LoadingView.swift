//
//  LoadingView.swift
//  App
//
//  Created by Shibo Tong on 19/8/21.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(Color.primaryDota, lineWidth: 5)
            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
            .animation(Animation.default.repeatForever(autoreverses: false))
            .onAppear {
                self.isLoading.toggle()
            }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
