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
    @FetchRequest(sortDescriptors: []) var heroes: FetchedResults<Hero>
    
    @State var gridView = true
    @State var selectedAttribute: HeroAttribute = .whole
    @State var searchString: String = ""
    @State var searchResults: [Hero] = []
    
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
        .searchable(text: $searchString.animation(.linear), placement: .automatic, prompt: "Search Heroes")
        .disableAutocorrection(true)
        .toolbar {
            if horizontalSize == .compact {
                toolBar
            }
        }
    }
    
    private var iPhone: some View {
        Group {
            if gridView {
                ScrollView(.vertical, showsIndicators: false) {
                    buildSection(heroes: searchResults, attributes: selectedAttribute)
                }
                .padding(.horizontal)
            } else {
                List {
                    buildSection(heroes: searchResults, attributes: selectedAttribute)
                }
                .listStyle(PlainListStyle())
            }
        }
    }
    
    private var iPad: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(HeroAttribute.allCases, id: \.self) { attribute in
                let heroes = heroes.filter { hero in
                    return hero.primaryAttr == attribute.rawValue
                }
                buildHeroGrid(heroes: heroes, attribute: attribute)
            }
        }
        .padding(.horizontal)
    }
    
    private var toolBar: some View {
        Menu {
            Picker("picker", selection: $gridView) {
                Label("Icons", systemImage: "square.grid.2x2").tag(true)
                Label("List", systemImage: "list.bullet").tag(false)
            }
            
            Picker("attributes", selection: $selectedAttribute) {
                Text("All").tag(HeroAttribute.whole)
                Label("STRENGTH", image: "attribute_str").tag(HeroAttribute.str)
                Label("AGILITY", image: "attribute_agi").tag(HeroAttribute.agi)
                Label("INTELLIGENCE", image: "attribute_int").tag(HeroAttribute.int)
                Label("UNIVERSAL", image: "attribute_all").tag(HeroAttribute.all)
            }
        } label: {
            if gridView {
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
                    NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: Int(hero.id)))) {
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
                        AttributeImage(attribute: selectedAttribute)
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
        if gridView {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 130, maximum: 200), spacing: 10, alignment: .leading), count: 1)) {
                ForEach(self.heroes) { hero in
                    NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: Int(hero.id)))) {
                        buildHero(hero: hero)
                    }
                }
            }
        } else {
            ForEach(heroes) { hero in
                NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: Int(hero.id)))) {
                    buildHero(hero: hero)
                }
            }
        }
    }
    
    @ViewBuilder private func buildHero(hero: Hero) -> some View {
        HeroListCellView(heroName: hero.heroNameLocalized,
                         heroID: Int(hero.id),
                         attribute: HeroAttribute(rawValue: hero.primaryAttr ?? "") ?? .agi,
                         isGrid: gridView,
                         isHighlighted: searchResults.contains(where: { $0.id == hero.id }) || searchString.isEmpty)
    }
}

struct HeroListView_Previews: PreviewProvider {
    static var previews: some View {
        HeroListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
