//
//  HeroListView.swift
//  App
//
//  Created by Shibo Tong on 29/10/21.
//
import SwiftUI

struct HeroListView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSize
    
    @State private var searchedResults: [Hero] = []
    @State private var selectedAttribute: HeroAttribute = .whole
    @State private var isGrid = true
    @State private var searchString = ""
    
    let heroes: [Hero]

    var body: some View {
        buildBody()
            .navigationTitle("Heroes")
            .searchable(
                text: $searchString.animation(.linear), placement: .automatic,
                prompt: "Search Heroes"
            )
            .disableAutocorrection(true)
            .toolbar {
                if horizontalSize == .compact {
                    Menu {
                        Picker("picker", selection: $isGrid) {
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
                        if isGrid {
                            Image(systemName: "square.grid.2x2")
                        } else {
                            Image(systemName: "list.bullet")
                        }
                    }
                }
            }
            .task {
                searchedResults = filterHero(searchText: searchString, selectedAttribute: selectedAttribute)
            }
            .onChange(of: searchString, action: { value in
                searchedResults = filterHero(searchText: value, selectedAttribute: selectedAttribute)
            })
            .onChange(of: selectedAttribute, action: { value in
                searchedResults = filterHero(searchText: searchString, selectedAttribute: value)
            })
    }

    private var gridView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            buildSection(heroes: searchedResults, attributes: selectedAttribute)
        }
        .padding(.horizontal)
    }
    
    private var listView: some View {
        List {
            buildSection(heroes: searchedResults, attributes: selectedAttribute)
        }
        .listStyle(PlainListStyle())
    }
    
    private var sectionView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(HeroAttribute.allCases, id: \.self) { attribute in
                let heroes = self.heroes.filter { hero in
                    return hero.primaryAttr == attribute.rawValue
                }
                buildHeroGrid(heroes: heroes, attribute: attribute)
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func buildBody() -> some View {
        if horizontalSize == .regular {
            sectionView
        } else if isGrid {
            gridView
        } else {
            listView
        }
    }

    @ViewBuilder
    private func buildHeroGrid(heroes: [Hero], attribute: HeroAttribute) -> some View {
        Section {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50, maximum: 50), spacing: 5, alignment: .leading),
                                     count: 1)) {
                ForEach(heroes) { hero in
                    NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: Int(hero.id)))) {
                        HeroRowView(hero: hero, isGrid: isGrid)
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

    @ViewBuilder
    private func buildSection(heroes: [Hero], attributes: HeroAttribute) -> some View {
        if heroes.count == 0 {
            Text("No Results")
                .bold()
                .foregroundColor(.secondaryLabel)
                .padding()
        } else {
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
        }
    }

    @ViewBuilder
    private func buildMainPart(heroes: [Hero]) -> some View {
        if isGrid {
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(
                        .adaptive(minimum: 130, maximum: 200), spacing: 10, alignment: .leading),
                    count: 1)
            ) {
                ForEach(heroes) { hero in
                    NavigationLink(
                        destination: HeroDetailView(vm: HeroDetailViewModel(heroID: Int(hero.id)))
                    ) {
                        HeroRowView(hero: hero, isGrid: isGrid)

                    }
                }
            }
        } else {
            ForEach(heroes) { hero in
                NavigationLink(
                    destination: HeroDetailView(vm: HeroDetailViewModel(heroID: Int(hero.id)))
                ) {
                    HeroRowView(hero: hero, isGrid: isGrid)
                }
            }
        }
    }
    
    private func filterHero(searchText: String, selectedAttribute: HeroAttribute) -> [Hero] {
        var searchedHeroes = heroes
        if selectedAttribute != .whole {
            searchedHeroes = searchedHeroes.filter({ $0.primaryAttr == selectedAttribute.rawValue })
        }
        if !searchText.isEmpty {
            searchedHeroes = searchedHeroes.filter({ $0.heroNameLocalized.lowercased().contains(searchText.lowercased()) })
        }
        return searchedHeroes
    }
}

#Preview {
    HeroListView(heroes: Hero.previewHeroes)
        .environment(\.managedObjectContext, PersistanceProvider.preview.container.viewContext)
        .environmentObject(ConstantsController.preview)
        .environmentObject(ImageController.preview)
}
