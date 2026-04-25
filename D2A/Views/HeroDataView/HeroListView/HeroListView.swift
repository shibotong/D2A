//
//  HeroListView.swift
//  App
//
//  Created by Shibo Tong on 29/10/21.
//

import SwiftUI
import CryptoKit

struct HeroListView: View {
    @EnvironmentObject var syncingService: StaticDataSyncingService
//    @ObservedObject var viewModel: HeroListViewModel
//    @Environment(\.horizontalSizeClass) private var horizontalSize
    
    init(heroes: [Hero]) {
//        viewModel = .init(heroes: heroes)
    }
    
    var body: some View {
//        if !syncingService.isCompleted && viewModel.heroes.isEmpty {
            HeroSyncingView(service: syncingService.currentSyncingService, progress: syncingService.syncingProgress)
//        } else {
            Text("abc")
//            buildBody()
//                .searchable(text: $viewModel.searchString.animation(.linear), placement: .automatic, prompt: "Search Heroes")
//                .disableAutocorrection(true)
//                .toolbar {
//                    if horizontalSize == .compact {
//                        Menu {
//                            Picker("picker", selection: $viewModel.gridView) {
//                                Label("Icons", systemImage: "square.grid.2x2").tag(true)
//                                Label("List", systemImage: "list.bullet").tag(false)
//                            }
//                            
//                            Picker("attributes", selection: $viewModel.selectedAttribute) {
//                                Text("All").tag(HeroAttribute.whole)
//                                Label("STRENGTH", image: "attribute_str").tag(HeroAttribute.str)
//                                Label("AGILITY", image: "attribute_agi").tag(HeroAttribute.agi)
//                                Label("INTELLIGENCE", image: "attribute_int").tag(HeroAttribute.int)
//                                Label("UNIVERSAL", image: "attribute_all").tag(HeroAttribute.all)
//                            }
//                        } label: {
//                            if viewModel.gridView {
//                                Image(systemName: "square.grid.2x2")
//                            } else {
//                                Image(systemName: "list.bullet")
//                            }
//                        }
//                    }
//                }
//        }
    }
    
//    @ViewBuilder private func buildBody() -> some View {
//        if horizontalSize == .compact {
//            if viewModel.gridView {
//                ScrollView(.vertical, showsIndicators: false) {
//                    buildSection(heroes: viewModel.searchResults, attributes: viewModel.selectedAttribute)
//                }
//                .padding(.horizontal)
//            } else {
//                List {
//                    buildSection(heroes: viewModel.searchResults, attributes: viewModel.selectedAttribute)
//                }
//                .listStyle(PlainListStyle())
//            }
//        } else {
//            ScrollView(.vertical, showsIndicators: false) {
//                ForEach(HeroAttribute.allCases, id: \.self) { attribute in
//                    let heroes = viewModel.heroes.filter { hero in
//                        return hero.primaryAttribute == attribute.rawValue
//                    }
//                    buildHeroGrid(heroes: heroes, attribute: attribute)
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//    
//    @ViewBuilder private func buildHeroGrid(heroes: [any HeroProtocol], attribute: HeroAttribute) -> some View {
//        Section {
//            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50, maximum: 50), spacing: 5, alignment: .leading), count: 1)) {
//                navigationHero(heroes: heroes)
//            }
//        } header: {
//            HStack {
//                AttributeImage(attribute: attribute)
//                    .frame(width: 20, height: 20)
//                Text(LocalizedStringKey(attribute.fullName)).bold()
//                Spacer()
//            }
//        }
//    }
//    
//    @ViewBuilder private func buildSection(heroes: [any HeroProtocol], attributes: HeroAttribute) -> some View {
//        if heroes.count == 0 {
//            Text("No Results")
//                .bold()
//                .foregroundColor(.secondaryLabel)
//                .padding()
//        } else {
//            Section {
//                buildMainPart(heroes: heroes)
//            } header: {
//                if attributes != .whole {
//                    HStack {
//                        AttributeImage(attribute: viewModel.selectedAttribute)
//                            .frame(width: 20, height: 20)
//                        Text(LocalizedStringKey(attributes.fullName))
//                            .bold()
//                        Spacer()
//                    }
//                } else {
//                    EmptyView()
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder private func buildMainPart(heroes: [any HeroProtocol]) -> some View {
//        if viewModel.gridView {
//            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 130, maximum: 200), spacing: 10, alignment: .leading), count: 1)) {
//                navigationHero(heroes: heroes)
//            }
//        } else {
//            navigationHero(heroes: heroes)
//        }
//    }
//    
//    @ViewBuilder private func buildHero(hero: any HeroProtocol) -> some View {
//        if horizontalSize == .regular {
//            HeroImageView(heroID: hero.id, type: .vert)
//                .clipShape(RoundedRectangle(cornerRadius: 8))
//                .opacity(viewModel.searchResults.contains(where: { $0.id == hero.id }) || viewModel.searchString.isEmpty ? 1 : 0.2)
//                .accessibilityIdentifier(hero.localizedName)
//        } else {
//            if viewModel.gridView {
//                ZStack {
//                    HeroImageView(heroID: hero.id, type: .full)
//                        .overlay(LinearGradient(colors: [.black.opacity(0), .black.opacity(0), .black], startPoint: .top, endPoint: .bottom))
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .accessibilityIdentifier(hero.localizedName)
//                    HStack {
//                        VStack {
//                            Spacer()
//                            HStack(spacing: 3) {
//                                AttributeImage(attribute: HeroAttribute(rawValue: hero.primaryAttribute)).frame(width: 15, height: 15)
//                                Text(hero.localizedName)
//                                    .font(.caption2)
//                                    .fontWeight(.black)
//                                    .foregroundColor(.white)
//                            }
//                        }
//                        Spacer()
//                    }
//                    .padding(5)
//                }
//            } else {
//                HStack {
//                    HeroImageView(heroID: hero.id, type: .full)
//                        .frame(width: 70)
//                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                    Text(hero.localizedName)
//                    Spacer()
//                    Image("attribute\(hero.primaryAttribute)")
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func navigationHero(heroes: [any HeroProtocol]) -> some View {
//        ForEach(heroes, id: \.id) { hero in
//            NavigationLink(destination: HeroDetailView(hero: hero)) {
//                buildHero(hero: hero)
//            }
//        }
//    }
}

 struct HeroListView_Previews: PreviewProvider {
    static var previews: some View {
        HeroListView(heroes: PreviewData.heroes)
//            .environmentObject(PreviewData.syncingService)
//            .environmentObject(PreviewData.environment)
    }
 }
