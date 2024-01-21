//
//  AbilityTitleView.swift
//  D2A
//
//  Created by Shibo Tong on 21/1/2024.
//
//
 import SwiftUI

struct AbilityTitleView: View {
    
    @State var displayName: String
    @State var cd: String?
    @State var mc: String?
    
    @State var name: String
    @State var url: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AbilityImage(viewModel: AbilityImageViewModel(name: name, urlString: url))
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            VStack(alignment: .leading) {
                Text(displayName)
                    .font(.system(size: 18))
                    .bold()
                if let cd {
                    Text("Cooldown: \(cd)")
                        .font(.system(size: 14))
                        .foregroundColor(.secondaryLabel)
                }
                if let mc {
                    Text("Cost: \(mc)")
                        .font(.system(size: 14))
                        .foregroundColor(.secondaryLabel)
                }
            }
        }
    }
}

#Preview {
    AbilityTitleView(displayName: "Acid Spray",
                     cd: "10/20/30",
                     mc: "10/20/30",
                     name: "acid Spray",
                     url: "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/abilities/alchemist_acid_spray.png")

}
