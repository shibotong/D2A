//
//  LoadingView.swift
//  App
//
//  Created by Shibo Tong on 19/8/21.
//

import SwiftUI

struct MainLoadingView: View {
    
    @Binding var status: LoadingStatus
    var envLoading: Bool
    
    var reloadData: () -> Void = {
        print("Button Pressed")
    }
    
    var body: some View {
        ZStack {
            Color.systemBackground
            Color.primaryDota.opacity(0.9)
            if status == .loading {
                Image("dota_armory_icon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            } else {
                Button {
                    reloadData()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.primaryDota)
                        Image(systemName: "wifi.exclamationmark")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .foregroundColor(.white)
                    }
                    .frame(width: 100, height: 100)
                }
            }
        }
        .ignoresSafeArea()
    }
}

 struct MainLoadingView_Previews: PreviewProvider {
    @State static var status: LoadingStatus = .error
    static var previews: some View {
        MainLoadingView(status: $status, envLoading: true)
    }
 }
