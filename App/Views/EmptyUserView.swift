//
//  EmptyUserView.swift
//  App
//
//  Created by Shibo Tong on 21/8/21.
//

import SwiftUI

struct EmptyUserView: View {
    @EnvironmentObject var env: DotaEnvironment
    var body: some View {
        VStack(spacing: 20) {
            Image("dota_armory_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            VStack {
                Text("No Following User").font(.custom(fontString, size: 30)).bold()
                Text("You don't have any following user at the moment").font(.custom(fontString, size: 20)).multilineTextAlignment(.center)
                    .foregroundColor(Color(.secondaryLabel))
            }.padding()
            Button(action: {
                env.addNewAccount.toggle()
            }) {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20)
                    .padding(25)
                    .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.primaryDota))
            }
        }
        .padding()
    }
}

struct EmptyUserView_Preview: PreviewProvider {
    static var previews: some View {
        EmptyUserView()
            .environmentObject(DotaEnvironment.shared)
    }
}
