//
//  HeroListView.swift
//  App
//
//  Created by Shibo Tong on 29/10/21.
//

import SwiftUI
import CryptoKit

struct HeroListView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSize
    
    @StateObject var viewModel = HeroListViewModel()
    
    var body: some View {
        Group {
            if horizontalSize == .compact {
                iPhone
            } else if horizontalSize == .regular {
                iPad
            } else {
                Text("No Horizontal Size")
            }
        }
        .navigationTitle("Heroes")
        .searchable(text: $viewModel.searchString.animation(.linear), placement: .automatic, prompt: "Search Heroes")
        .disableAutocorrection(true)
        .toolbar {
            if horizontalSize == .compact {
                toolBar
            }
        }
    }
    
    private var iPhone: some View {
        Group {
            if viewModel.gridView {
                ScrollView(.vertical, showsIndicators: false) {
                    buildSection(heroes: viewModel.searchResults, attributes: viewModel.selectedAttribute)
                }
                .padding(.horizontal)
            } else {
                List {
                    buildSection(heroes: viewModel.searchResults, attributes: viewModel.selectedAttribute)
                }
                .listStyle(PlainListStyle())
            }
        }
    }
    
    private var iPad: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(HeroAttribute.allCases, id: \.self) { attribute in
                let heroes = viewModel.searchResults.filter { hero in
                    return hero.primaryAttr == attribute.rawValue
                }
                buildHeroGrid(heroes: heroes, attribute: attribute)
            }
        }
        .padding(.horizontal)
    }
    
    private var toolBar: some View {
        Menu {
            Picker("picker", selection: $viewModel.gridView) {
                Label("Icons", systemImage: "square.grid.2x2").tag(true)
                Label("List", systemImage: "list.bullet").tag(false)
            }
            
            Picker("attributes", selection: $viewModel.selectedAttribute) {
                Text("All").tag(HeroAttribute.whole)
                Label("STRENGTH", image: "attribute_str").tag(HeroAttribute.str)
                Label("AGILITY", image: "attribute_agi").tag(HeroAttribute.agi)
                Label("INTELLIGENCE", image: "attribute_int").tag(HeroAttribute.int)
                Label("UNIVERSAL", image: "attribute_all").tag(HeroAttribute.all)
            }
        } label: {
            if viewModel.gridView {
                Image(systemName: "square.grid.2x2")
            } else {
                Image(systemName: "list.bullet")
            }
        }
    }
    
    @ViewBuilder private func buildHeroGrid(heroes: [Hero], attribute: HeroAttribute) -> some View {
        Section {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50, maximum: 50), spacing: 5, alignment: .leading), count: 1)) {
                ForEach(heroes) { hero in
                    NavigationLink(destination: HeroDetailViewV3(hero: hero)) {
                        buildHero(hero: hero)
                    }
                }
            }
        } header: {
            HStack {
                AttributeImage(attribute: attribute)
                    .frame(width: 20, height: 20)
                Text(LocalizedStringKey(attribute.fullName)).bold()
                Spacer()
            }
        }
    }
    
    @ViewBuilder private func buildSection(heroes: [Hero], attributes: HeroAttribute) -> some View {
//        if heroes.count == 0 {
//            Text("No Results")
//                .bold()
//                .foregroundColor(.secondaryLabel)
//                .padding()
//        } else {
            Section {
                buildMainPart(heroes: heroes)
            } header: {
                if attributes != .whole {
                    HStack {
                        AttributeImage(attribute: viewModel.selectedAttribute)
                            .frame(width: 20, height: 20)
                        Text(LocalizedStringKey(attributes.fullName))
                            .bold()
                        Spacer()
                    }
                } else {
                    EmptyView()
                }
            }
//        }
    }
    
    @ViewBuilder private func buildMainPart(heroes: [Hero]) -> some View {
        if viewModel.gridView {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 130, maximum: 200), spacing: 10, alignment: .leading), count: 1)) {
                ForEach(viewModel.searchResults) { hero in
                    NavigationLink(destination: HeroDetailViewV3(hero: hero)) {
                        buildHero(hero: hero)
                    }
                }
            }
        } else {
            ForEach(heroes) { hero in
                NavigationLink(destination: HeroDetailViewV3(hero: hero)) {
                    buildHero(hero: hero)
                }
            }
        }
    }
    
    @ViewBuilder private func buildHero(hero: Hero) -> some View {
        HeroListCellView(heroName: hero.heroNameLocalized,
                         heroID: Int(hero.id),
                         attribute: HeroAttribute(rawValue: hero.primaryAttr ?? "") ?? .agi,
                         isGrid: viewModel.gridView,
                         isHighlighted: viewModel.searchResults.contains(where: { $0.id == hero.id }) || viewModel.searchString.isEmpty)
    }
}

struct HeroListView_Previews: PreviewProvider {
    static var previews: some View {
        HeroListView(viewModel: HeroListViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
