//
//  StratzTokenView.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

import SwiftUI

struct StratzTokenView: View {
    
    @AppStorage("stratzToken") private var stratzToken: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Enter your Stratz token")
                        .font(.system(size: 15))
                        .bold()
                    Spacer()
                }
                TextField("Stratz Token", text: $stratzToken)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .background(RoundedRectangle(cornerRadius: 10).stroke().foregroundColor(.primaryDota))
                    .keyboardType(.numberPad)
            }
            .padding()
            .background(Color.systemBackground)
        }
        .navigationTitle("Stratz Token")
    }
}

#Preview {
    NavigationView {
        StratzTokenView()
    }
}
