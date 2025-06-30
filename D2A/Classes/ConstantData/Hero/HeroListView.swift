//
//  HeroListView.swift
//  App
//
//  Created by Shibo Tong on 29/10/21.
//
import SwiftUI



struct HeroListView: View {
    
    fileprivate enum AttributeSelection: String, CaseIterable {
        case all = "All"
        case str = "Strength"
        case agi = "Agility"
        case int = "Intelligence"
        case uni = "Universal"
        
        var attributes: [HeroAttribute] {
            switch self {
            case .all: return [.str, .agi, .int, .uni]
            case .str: return [.str]
            case .agi: return [.agi]
            case .int: return [.int]
            case .uni: return [.uni]
            }
        }
        
        var image: String {
            switch self {
            case .all: return ""
            case .str: return "attribute_str"
            case .agi: return "attribute_agi"
            case .int: return "attribute_int"
            case .uni: return "attribute_uni"
            }
        }
    }
    
    @Environment(\.horizontalSizeClass) private var horizontalSize
    
    @State private var searchedResults: [Hero] = []
    @State private var selectedAttribute: AttributeSelection = .all
    
    @State private var selectedAttributes: Set<HeroAttribute> = []
    
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
                    menu
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
    
    private var menu: Menu<some View, some View> {
        Menu {
            Picker("picker", selection: $isGrid) {
                Label("Icons", systemImage: "square.grid.2x2").tag(true)
                Label("List", systemImage: "list.bullet").tag(false)
            }
            
            Picker("attributes", selection: $selectedAttribute) {
                ForEach(AttributeSelection.allCases, id: \.rawValue) { selection in
                    Label(selection.rawValue, image: selection.image).tag(selection)
                }
            }
        } label: {
            if isGrid {
                Image(systemName: "square.grid.2x2")
            } else {
                Image(systemName: "list.bullet")
            }
        }
    }

    private var gridView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            buildSection(heroes: searchedResults)
        }
        .padding(.horizontal)
    }
    
    private var listView: some View {
        List {
            buildSection(heroes: searchedResults)
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
    private func buildSection(heroes: [Hero]) -> some View {
        if heroes.count == 0 {
            Text("No Results")
                .bold()
                .foregroundColor(.secondaryLabel)
                .padding()
        } else {
            buildMainPart(heroes: heroes)
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
    
    private func filterHero(searchText: String, selectedAttribute: AttributeSelection) -> [Hero] {
        var searchedHeroes = heroes
        searchedHeroes = searchedHeroes.filter { hero in
            selectedAttribute.attributes.map { $0.rawValue }.contains(hero.primaryAttr)
        }
        if !searchText.isEmpty {
            searchedHeroes = searchedHeroes.filter({ $0.heroNameLocalized.lowercased().contains(searchText.lowercased()) })
        }
        return searchedHeroes
    }
}

#Preview {
    NavigationView {
        HeroListView(heroes: Hero.previewHeroes.sorted(by: { $0.heroNameLocalized < $1.heroNameLocalized }))
            .environmentObject(ConstantsController.preview)
            .environmentObject(ImageController.preview)
    }
}
