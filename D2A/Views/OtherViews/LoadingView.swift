//
//  LoadingView.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import SwiftUI

struct LoadingView: View {
  var body: some View {
    VStack {
      ProgressView()
      Text("LOADING")
        .foregroundColor(.secondaryLabel)
        .font(.footnote)
    }
  }
}

struct LoadingView_Previews: PreviewProvider {
  static var previews: some View {
    LoadingView()
  }
}
