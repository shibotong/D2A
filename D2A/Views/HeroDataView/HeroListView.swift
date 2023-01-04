//
//  HeroListView.swift
//  App
//
//  Created by Shibo Tong on 29/10/21.
//

import SwiftUI
import CryptoKit

struct HeroListView: View {
    @StateObject var vm = HeroListViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSize
    
    private let heroAttributes = ["str", "agi", "int"]
    private let heroAttributesTitle = ["str": "Strength", "agi": "Agility", "int": "Intelligence"]
    
    var body: some View {
        buildBody()
            .navigationTitle("Heroes")
            .searchable(text: $vm.searchString.animation(.linear), placement: .automatic, prompt: "Search Heroes")
            .disableAutocorrection(true)
            .toolbar {
                if horizontalSize == .compact {
                    Menu {
                        Picker("picker", selection: $vm.gridView) {
                            Label("Icons", systemImage: "square.grid.2x2").tag(true)
                            Label("List", systemImage: "list.bullet").tag(false)
                        }
                        
                        Picker("attributes", selection: $vm.attributes) {
                            Text("All").tag(HeroAttributes.all)
                            Label("Strength", image: "hero_str").tag(HeroAttributes.str)
                            Label("Agility", image: "hero_agi").tag(HeroAttributes.agi)
                            Label("Intelligence", image: "hero_int").tag(HeroAttributes.int)
                        }
                    } label: {
                        if vm.gridView {
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
            if vm.gridView {
                ScrollView(.vertical, showsIndicators: false) {
                    buildSection(heroes: vm.searchResults, attributes: vm.attributes)
                }
                .padding(.horizontal)
            } else {
                List {
                    buildSection(heroes: vm.searchResults, attributes: vm.attributes)
                }
                .listStyle(PlainListStyle())
            }
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(heroAttributes, id: \.self) { attribute in
                    let heroes = vm.heroList.filter { hero in
                        return hero.primaryAttr == attribute
                    }
                    buildHeroGrid(heroes: heroes, title: heroAttributesTitle[attribute]!, icon: attribute)
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder private func buildHeroGrid(heroes: [HeroCodable], title: String, icon: String) -> some View {
        Section {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50, maximum: 50), spacing: 5, alignment: .leading), count: 1)) {
                ForEach(heroes) { hero in
                    NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: hero.id))) {
                        buildHero(hero: hero)
                    }
                }
            }
        } header: {
            HStack {
                Image("hero_\(icon)")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(LocalizedStringKey(title))
                Spacer()
            }
        }
    }
    
    @ViewBuilder private func buildSection(heroes: [HeroCodable], attributes: HeroAttributes) -> some View {
        if heroes.count == 0 {
            Text("No Results")
                .bold()
                .foregroundColor(.secondaryLabel)
                .padding()
        } else {
            Section {
                buildMainPart(heroes: heroes)
            } header: {
                if attributes != .all {
                    HStack {
                        Image("hero_\(vm.attributes.rawValue)")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("\(attributes.fullName)")
                            .bold()
                        Spacer()
                    }
                } else {
                    EmptyView()
                }
            }
        }
    }
    
    @ViewBuilder private func buildMainPart(heroes: [HeroCodable]) -> some View {
        if vm.gridView {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 130, maximum: 200), spacing: 10, alignment: .leading), count: 1)){
                ForEach(heroes) { hero in
                    NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: hero.id))) {
                        buildHero(hero: hero)
                    }
                }
            }
        } else {
            ForEach(heroes) { hero in
                NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: hero.id))) {
                    buildHero(hero: hero)
                }
            }
        }
    }
    
    @ViewBuilder private func buildHero(hero: HeroCodable) -> some View {
        if horizontalSize == .regular {
            HeroImageView(heroID: hero.id, type: .vert)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .opacity(vm.searchResults.contains(where: { $0.id == hero.id }) || vm.searchString.isEmpty ? 1 : 0.2)
        } else {
            if vm.gridView {
                ZStack {
                    HeroImageView(heroID: hero.id, type: .full)
                        .overlay(LinearGradient(colors: [.black.opacity(0),.black.opacity(0), .black], startPoint: .top, endPoint: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    HStack {
                        VStack {
                            Spacer()
                            HStack(spacing: 3) {
                                Image("hero_\(hero.primaryAttr)").resizable().frame(width: 15, height: 15)
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
                    HeroImageView(heroID: hero.id, type: .full)
                        .frame(width: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Text(hero.heroNameLocalized)
                    Spacer()
                    Image("hero_\(hero.primaryAttr)")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

//struct HeroListView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeroListView()
//    }
//}
