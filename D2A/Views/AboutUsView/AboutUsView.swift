//
//  AboutUsView.swift
//  App
//
//  Created by Shibo Tong on 22/8/21.
//

import SwiftUI

struct AboutUsView: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var logger: D2ALogger

    #if DEBUG
        @EnvironmentObject var heroData: HeroDatabase
        @Environment(\.managedObjectContext) var context
    #endif

    @Environment(\.presentationMode) var presentState
    private var versionNumber: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            ?? NSLocalizedString("Error", comment: "Cannot get version number")
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            ?? NSLocalizedString("Error", comment: "Cannot get build number")
    }

    var body: some View {
        List {
            #if DEBUG
                Section(header: Text("DEBUG")) {
                    NavigationLink(destination: DebugView()) {
                        makeDetailRow(
                            image: "chevron.left.slash.chevron.right", text: "Console Logging",
                            detail: logger.loggingLevel.icon)
                    }
                    makeButton(image: "trash", text: "Clear cache") {
                        Task {
                            await heroData.resetHeroData(context: context)
                        }
                    }
                }
            #endif

            Section(header: Text("Our App")) {
                makeButton(image: "cart", text: "Unlock All Features") {
                    presentState.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 0.5,
                        execute: {
                            // show subscription after 0.5s
                            env.subscriptionSheet = true
                        })
                }
                makeRow(
                    image: "chevron.left.slash.chevron.right",
                    text: "Source Code / Report an Issue",
                    link: URL(string: "https://github.com/shibotong/Dota2Armory"))
                makeRow(
                    image: "star", text: "Rate the app on App Store",
                    link: URL(string: "https://apps.apple.com/au/app/dota2armory/id1582344852"))
                makeRow(image: "lock", text: "Privacy Policy", link: URL(string: PRIVACY_POLICY))
                makeRow(image: "person", text: "Terms of Use", link: URL(string: TERMS_OF_USE))

                makeDetailRow(
                    image: "app.badge", text: "App Version",
                    detail: "\(versionNumber)(\(buildNumber))")
                NavigationLink(destination: StratzTokenView()) {
                    makeDetailRow(
                        image: "chevron.left.slash.chevron.right", text: "Stratz Token", detail: "")
                }

            }
            Section(header: Text("Thanks To")) {
                makeRow(
                    image: "heart.fill", text: "OpenDotaAPI",
                    link: URL(string: "https://www.opendota.com"))
                makeRow(
                    image: "heart.fill", text: "STRATZ API",
                    link: URL(string: "https://stratz.com/dashboard")
                )
                makeRow(
                    image: "heart.fill", text: "Our Loved Dota2",
                    link: URL(string: "https://www.dota2.com/home"))
            }
        }
        .navigationTitle("About")
        .listStyle(InsetGroupedListStyle())
    }

    private func makeRow(
        image: String,
        text: LocalizedStringKey,
        link: URL? = nil
    ) -> some View {
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

    private func makeButton(image: String, text: LocalizedStringKey, action: @escaping () -> Void)
        -> some View
    {
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
            .environment(\.managedObjectContext, PersistanceProvider.preview.container.viewContext)
            .environmentObject(D2ALogger())
            .environmentObject(HeroDatabase.preview)

    }
}
