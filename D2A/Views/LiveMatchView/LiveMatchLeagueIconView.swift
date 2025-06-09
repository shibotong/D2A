//
//  LiveMatchLeagueIconView.swift
//  D2A
//
//  Created by Shibo Tong on 28/6/2023.
//

import SwiftUI

struct LiveMatchLeagueIconView: View {

    @ObservedObject var viewModel: LiveMatchLeagueIconViewModel

    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Image("league_template")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
            }
        }
        .cornerRadius(5)
    }
}

struct LiveMatchLeagueIconView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchLeagueIconView(viewModel: LiveMatchLeagueIconViewModel(leagueID: 15353))
    }
}
