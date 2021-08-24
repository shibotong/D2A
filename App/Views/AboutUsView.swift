//
//  AboutUsView.swift
//  App
//
//  Created by Shibo Tong on 22/8/21.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                Text("123")
            }
            .navigationBarItems(leading: Button(action: {}) {
                Image(systemName: "xmark.circle.fill")
            })
            .navigationTitle("About")
        }
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {

        AboutUsView()
        
    }
}
