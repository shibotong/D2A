//
//  AbilityTitleView.swift
//  D2A
//
//  Created by Shibo Tong on 21/1/2024.
//
//
 import SwiftUI

struct AbilityTitleView: View {
    
    @EnvironmentObject var environment: DotaEnvironment
    
    let displayName: String
    let cd: String?
    let mc: String?
    
    let name: String?
    
    private let imageSize: CGFloat = 80
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let name {
                AbilityImage(name: name, imageProvider: environment.imageProvider)
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            VStack(alignment: .leading) {
                Text(displayName)
                    .font(.title)
                    .bold()
                if let cd {
                    Text("Cooldown: \(cd)")
                        .font(.body)
                        .foregroundColor(.secondaryLabel)
                }
                if let mc {
                    Text("Cost: \(mc)")
                        .font(.body)
                        .foregroundColor(.secondaryLabel)
                }
            }
            Spacer()
        }
    }
}

#if DEBUG
#Preview {
    AbilityTitleView(displayName: "Blink",
                     cd: "10/20/30",
                     mc: "10/20/30",
                     name: "antimage_blink")
    .environmentObject(PreviewData.environment)
}
#endif
