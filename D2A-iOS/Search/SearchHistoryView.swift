//
//  SearchHistoryView.swift
//  D2A
//
//  Created by Shibo Tong on 16/8/2025.
//

import SwiftUI

struct SearchHistoryView: View {
    let searchHistory: [String]
    
    var body: some View {
        ForEach(searchHistory, id: \.self) { text in
            Label("\(text)", systemImage: "magnifyingglass")
                .searchCompletion(text)
        }
    }
}

#Preview {
    SearchHistoryView(searchHistory: ["a", "b", "c"])
}
