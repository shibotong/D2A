//
//  AboutUsView.swift
//  App
//
//  Created by Shibo Tong on 22/8/21.
//

import SwiftUI

struct AboutUsView: View {
    @EnvironmentObject var env: DotaEnvironment
    @Environment(\.presentationMode) var presentState
    private var versionNumber: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? NSLocalizedString("Error", comment: "")
    }
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Our App")) {
                    makeButton(image: "cart", text: "Unlock All Features") {
                        self.presentState.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            // show subscription after 0.5s
                            self.env.subscriptionSheet = true
                        })
                    }
                    makeRow(image: "chevron.left.slash.chevron.right", text: "Source Code / Report an Issue", link: URL(string: "https://github.com/shibotong/Dota2Armory"))
                    makeRow(image: "star", text: "Rate the app on App Store", link: URL(string: "https://apps.apple.com/au/app/dota2armory/id1582344852"))
                    makeRow(image: "lock", text: "Privacy Policy", link: URL(string: PRIVACY_POLICY))
                    makeRow(image: "person", text: "Terms of Use", link: URL(string: TERMS_OF_USE))
                    
                    makeDetailRow(image: "app.badge", text: "App Version", detail: versionNumber)
                }
                Section(header: Text("Thanks To")) {
                    makeRow(image: "heart.fill", text: "OpenDotaAPI", link: URL(string: "https://www.opendota.com"))
                    makeRow(image: "heart.fill", text: "Our Loved Dota2", link: URL(string: "https://www.dota2.com/home"))
                }
            }
            .navigationTitle("About")
//            .navigationBarTitleDisplayMode(.inline)
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    private func makeRow(image: String,
                         text: LocalizedStringKey,
                         link: URL? = nil) -> some View {
        HStack {
            Image(systemName: image)
                .imageScale(.medium)
                .foregroundColor(.primaryDota)
                .frame(width: 30)
            Group {
                if let link = link {
                    Link(text, destination: link)
                        .foregroundColor(Color(.label))
                } else {
                    Text(text)
                }
            }
            .font(.custom(fontString, size: 18))
            Spacer()
            Image(systemName: "chevron.right").imageScale(.medium)
        }
    }
    
    private func makeDetailRow(image: String, text: LocalizedStringKey, detail: String) -> some View {
        HStack {
            Image(systemName: image)
                .imageScale(.medium)
                .foregroundColor(.primaryDota)
                .frame(width: 30)
            Text(text)
            Spacer()
            Text(detail)
                .foregroundColor(.gray)
                .font(.callout)
        }
    }
    
    private func makeButton(image: String, text: LocalizedStringKey, action: @escaping () -> ()) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: image)
                    .imageScale(.medium)
                    .foregroundColor(.primaryDota)
                    .frame(width: 30)
                Text(text)
                    .foregroundColor(Color(.label))
                Spacer()
            }
        }
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
