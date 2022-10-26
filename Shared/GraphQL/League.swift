//
//  League.swift
//  D2A
//
//  Created by Shibo Tong on 25/10/2022.
//

import Foundation
import SwiftUI

extension League {
    var image: some View {
        AsyncImage(url: URL(string: "https://cdn.stratz.com/images/dota2/leagues/\(self.id ?? 0).png")) { image in
            image
                .resizable()
        } placeholder: {
            Color.secondarySystemBackground
        }
    }
}
