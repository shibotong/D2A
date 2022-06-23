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
//        Circle()
//            .trim(from: 0, to: 0.8)
//            .stroke(Color.primaryDota, lineWidth: 2)
//            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
//            .onAppear {
//                DispatchQueue.main.async {
//                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
//                        self.isLoading.toggle()
//                    }
//                }
//            }
        ZStack {
            Color.systemBackground
            Color.primaryDota.opacity(0.9)
            Image("dota_armory_icon")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .ignoresSafeArea()
            
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        
        LoadingView()
            .preferredColorScheme(.light)
        LoadingView()
            .preferredColorScheme(.dark)
        
    }
}
