//
//  LiveMatchTeamView.swift
//  D2A
//
//  Created by Shibo Tong on 15/6/2023.
//

import SwiftUI

struct LiveMatchTeamIconView: View {
    let url: String
    let isRadiant: Bool
    var body: some View {
        AsyncImage(url: URL(string: url)) { result in
            switch result {
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            default:
                Image("icon_\(isRadiant ? "radiant" : "dire")")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .cornerRadius(5)
    }
}

struct LiveMatchTeamIconView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchTeamIconView(url: "", isRadiant: true)
    }
}
