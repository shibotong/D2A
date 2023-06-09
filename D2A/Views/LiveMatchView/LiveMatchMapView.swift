//
//  LiveMatchMapView.swift
//  D2A
//
//  Created by Shibo Tong on 9/6/2023.
//

import SwiftUI

struct LiveMatchMapView: View {
    
    
    
    var body: some View {
        Image("live_map")
            .resizable()
            .scaledToFit()
            .background(Color.label.opacity(0.3))
    }
}

struct LiveMatchMapView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchMapView()
    }
}
