//
//  HeroListView.swift
//  App
//
//  Created by Shibo Tong on 29/10/21.
//
import SwiftUI



struct HeroListView: View {
    
    @Environment(\.horizontalSizeClass)
    private var horizontalSize
    
    @ObservedObject
    private var viewModel: ViewModel
    
    @State
    private var isGrid = true
    
    init(heroes: [Hero]) {
        viewModel = ViewModel(heroes: heroes)
    }

    var body: some View {
        buildBody()
            .navigationTitle("Heroes")
            .searchable(
                text: $viewModel.searchString.animation(.linear),
                placement: .automatic,
                prompt: "Search Heroes"
            )
            .disableAutocorrection(true)
            .toolbar {
                if horizontalSize == .compact {
                    menu
                }
            }
    }
    
    private var menu: Menu<some View, some View> {
        Menu {
            Picker("picker", selection: $isGrid) {
                Label("Icons", systemImage: "square.grid.2x2").tag(true)
                Label("List", systemImage: "list.bullet").tag(false)
            }
            
            Picker("attributes", selection: $viewModel.selectedAttribute) {
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
            buildSection(heroes: viewModel.searchedResults)
        }
        .padding(.horizontal)
    }
    
    private var listView: some View {
        List {
            buildSection(heroes: viewModel.searchedResults)
        }
        .listStyle(PlainListStyle())
    }
    
    private var sectionView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(HeroAttribute.allCases, id: \.self) { attribute in
                let heroes = viewModel.heroes.filter { hero in
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
                Image(attribute.image)
                    .resizable()
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
}

#Preview {
    NavigationView {
        HeroListView(heroes: Hero.previewHeroes.sorted(by: { $0.heroNameLocalized < $1.heroNameLocalized }))
            .environmentObject(ConstantsController.preview)
            .environmentObject(ImageController.preview)
    }
}
