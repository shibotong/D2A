//
//  LiveMatchTeamView.swift
//  D2A
//
//  Created by Shibo Tong on 15/6/2023.
//

import SwiftUI

struct LiveMatchTeamIconView: View {

  @ObservedObject var viewModel: LiveMatchTeamIconViewModel

  var body: some View {
    ZStack {
      if let image = viewModel.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
      } else {
        Image("icon_\(viewModel.isRadiant ? "radiant" : "dire")")
          .resizable()
          .scaledToFit()
      }
    }
    .cornerRadius(5)
  }
}
