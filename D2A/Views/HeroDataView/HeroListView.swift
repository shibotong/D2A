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
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id)])
    var heroes: FetchedResults<Hero>
    
    @State private var searchString: String = ""
    @State private var isGridView: Bool = true
    
    @State private var filteredHeroes: [Hero] = []
    @State private var selectedAttribute: AttributeSelection = .whole
    
    var body: some View {
        buildBody()
            .navigationTitle("Heroes")
            .searchable(text: $searchString.animation(.linear), placement: .automatic, prompt: "Search Heroes")
            .disableAutocorrection(true)
            .toolbar {
                if horizontalSize == .compact {
                    Menu {
                        Picker("picker", selection: $isGridView) {
                            Label("Icons", systemImage: "square.grid.2x2").tag(true)
                            Label("List", systemImage: "list.bullet").tag(false)
                        }
                        
                        Picker("attributes", selection: $selectedAttribute) {
                            Text("All").tag(AttributeSelection.whole)
                            Label("STRENGTH", image: "attribute_str").tag(AttributeSelection.str)
                            Label("AGILITY", image: "attribute_agi").tag(AttributeSelection.agi)
                            Label("INTELLIGENCE", image: "attribute_int").tag(AttributeSelection.int)
                            Label("UNIVERSAL", image: "attribute_all").tag(AttributeSelection.uni)
                        }
                    } label: {
                        if isGridView {
                            Image(systemName: "square.grid.2x2")
                        } else {
                            Image(systemName: "list.bullet")
                        }
                    }
                }
            }
    }
    
    @ViewBuilder private func buildBody() -> some View {
        if horizontalSize == .compact {
            if isGridView {
                ScrollView(.vertical, showsIndicators: false) {
                    buildSection(heroes: filteredHeroes, attributes: selectedAttribute)
                }
                .padding(.horizontal)
            } else {
                List {
                    buildSection(heroes: filteredHeroes, attributes: selectedAttribute)
                }
                .listStyle(PlainListStyle())
            }
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(AttributeSelection.allCases, id: \.self) { attribute in
                    let heroes = heroes.filter { hero in
                        return hero.primaryAttr == attribute.rawValue
                    }
                    buildHeroGrid(heroes: heroes, attribute: attribute)
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder private func buildHeroGrid(heroes: [Hero], attribute: AttributeSelection) -> some View {
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
    
    @ViewBuilder private func buildSection(heroes: [Hero], attributes: AttributeSelection) -> some View {
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
    
    @ViewBuilder private func buildMainPart(heroes: [Hero]) -> some View {
        if isGridView {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 130, maximum: 200), spacing: 10, alignment: .leading), count: 1)) {
                ForEach(heroes) { hero in
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
    
    @ViewBuilder
    private func buildHero(hero: Hero) -> some View {
        if horizontalSize == .regular {
            HeroImageView(heroID: Int(hero.id), type: .vert)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .opacity(filteredHeroes.contains(where: { $0.id == hero.id }) || searchString.isEmpty ? 1 : 0.2)
                .accessibilityIdentifier(hero.heroNameLocalized)
        } else {
            if isGridView {
                ZStack {
                    HeroImageView(heroID: Int(hero.id), type: .full)
                        .overlay(LinearGradient(colors: [.black.opacity(0), .black.opacity(0), .black], startPoint: .top, endPoint: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .accessibilityIdentifier(hero.heroNameLocalized)
                    HStack {
                        VStack {
                            Spacer()
                            HStack(spacing: 3) {
                                AttributeImage(attribute: AttributeSelection(rawValue: hero.primaryAttr!)).frame(width: 15, height: 15)
                                Text(hero.heroNameLocalized)
                                    .font(.caption2)
                                    .fontWeight(.black)
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                    }
                    .padding(5)
                }
            } else {
                HStack {
                    HeroImageView(heroID: Int(hero.id), type: .full)
                        .frame(width: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Text(hero.heroNameLocalized)
                    Spacer()
                    Image("hero_\(hero.primaryAttr!)")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

 struct HeroListView_Previews: PreviewProvider {
    static var previews: some View {
        HeroListView()
    }
 }
