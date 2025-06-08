//
//  StratzTokenView.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

import SwiftUI

struct StratzTokenView: View {

  @AppStorage(UserDefaults.stratzToken, store: UserDefaults.group)
  private var stratzToken: String = ""

  @State private var editToken: String = ""

  @Environment(\.dismiss) var dismiss

  var body: some View {
    ScrollView {
      VStack {
        HStack {
          Text("Enter your Stratz token")
            .font(.system(size: 15))
            .bold()
          Spacer()
        }
        TextField("Stratz Token", text: $editToken)
          .padding()
          .clipShape(RoundedRectangle(cornerRadius: 10))
          .background(RoundedRectangle(cornerRadius: 10).stroke().foregroundColor(.primaryDota))
          .keyboardType(.numberPad)
      }
      .padding()
      .background(Color.systemBackground)
    }
    .navigationTitle("Stratz Token")
    .task {
      editToken = stratzToken
    }
    .toolbar {
      ToolbarItem {
        Button("Save") {
          stratzToken = editToken
          NotificationCenter.stratzToken.send(stratzToken)
          dismiss()
        }
      }
    }
  }
}

#Preview {
  NavigationView {
    StratzTokenView()
  }
}
