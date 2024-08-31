//
//  HeroDetailViewV2.swift
//  D2A
//
//  Created by Shibo Tong on 30/8/2024.
//

import SwiftUI

struct HeroDetailViewV2: View {
    
    @State private var heroLevel = 1.00
    
    var body: some View {
        Slider(value: $heroLevel, in: 1...30, step: 1) {
            Text("Level \(Int(heroLevel))")
        } minimumValueLabel: {
            Text("\(Int(heroLevel))")
        } maximumValueLabel: {
            Text("30")
        }
    }
}

 #Preview {
     HeroDetailViewV2()
 }
