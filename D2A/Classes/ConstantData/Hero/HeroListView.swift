import CryptoKit
//
//  HeroListView.swift
//  App
//
//  Created by Shibo Tong on 29/10/21.
//
import SwiftUI

struct HeroListView: View {
    @StateObject var vm = HeroListViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSize

    var body: some View {
        buildBody()
            .navigationTitle("Heroes")
            .searchable(
                text: $vm.searchString.animation(.linear), placement: .automatic,
                prompt: "Search Heroes"
            )
            .disableAutocorrection(true)
            .toolbar {
                if horizontalSize == .compact {
                    Menu {
                        Picker("picker", selection: $vm.gridView) {
                            Label("Icons", systemImage: "square.grid.2x2").tag(true)
                            Label("List", systemImage: "list.bullet").tag(false)
                        }

                        Picker("attributes", selection: $vm.selectedAttribute) {
                            Text("All").tag(HeroAttribute.whole)
                            Label("STRENGTH", image: "attribute_str").tag(HeroAttribute.str)
                            Label("AGILITY", image: "attribute_agi").tag(HeroAttribute.agi)
                            Label("INTELLIGENCE", image: "attribute_int").tag(HeroAttribute.int)
                            Label("UNIVERSAL", image: "attribute_all").tag(HeroAttribute.all)
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
                    buildSection(heroes: vm.searchResults, attributes: vm.selectedAttribute)
                }
                .padding(.horizontal)
            } else {
                List {
                    buildSection(heroes: vm.searchResults, attributes: vm.selectedAttribute)
                }
                .listStyle(PlainListStyle())
            }
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(HeroAttribute.allCases, id: \.self) { attribute in
                    let heroes = vm.heroList.filter { hero in
                        return hero.primaryAttr == attribute.rawValue
                    }
                    buildHeroGrid(heroes: heroes, attribute: attribute)
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder private func buildHeroGrid(heroes: [ODHero], attribute: HeroAttribute) -> some View {
        Section {
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(
                        .adaptive(minimum: 50, maximum: 50), spacing: 5, alignment: .leading),
                    count: 1)
            ) {
                ForEach(heroes) { hero in
                    NavigationLink(
                        destination: HeroDetailView(vm: HeroDetailViewModel(heroID: hero.id))
                    ) {
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

    @ViewBuilder private func buildSection(heroes: [ODHero], attributes: HeroAttribute) -> some View {
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
                        AttributeImage(attribute: vm.selectedAttribute)
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

    @ViewBuilder private func buildMainPart(heroes: [ODHero]) -> some View {
        if vm.gridView {
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(
                        .adaptive(minimum: 130, maximum: 200), spacing: 10, alignment: .leading),
                    count: 1)
            ) {
                ForEach(heroes) { hero in
                    NavigationLink(
                        destination: HeroDetailView(vm: HeroDetailViewModel(heroID: hero.id))
                    ) {
                        buildHero(hero: hero)

                    }
                }
            }
        } else {
            ForEach(heroes) { hero in
                NavigationLink(
                    destination: HeroDetailView(vm: HeroDetailViewModel(heroID: hero.id))
                ) {
                    buildHero(hero: hero)
                }
            }
        }
    }

    @ViewBuilder private func buildHero(hero: ODHero) -> some View {
        if horizontalSize == .regular {
            HeroImageView(heroID: hero.id, type: .vert)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .opacity(
                    vm.searchResults.contains(where: { $0.id == hero.id })
                        || vm.searchString.isEmpty
                        ? 1 : 0.2
                )
                .accessibilityIdentifier(hero.heroNameLocalized)
        } else {
            if vm.gridView {
                ZStack {
                    HeroImageView(heroID: hero.id, type: .full)
                        .overlay(
                            LinearGradient(
                                colors: [.black.opacity(0), .black.opacity(0), .black],
                                startPoint: .top,
                                endPoint: .bottom)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .accessibilityIdentifier(hero.heroNameLocalized)
                    HStack {
                        VStack {
                            Spacer()
                            HStack(spacing: 3) {
                                AttributeImage(attribute: HeroAttribute(rawValue: hero.primaryAttr))
                                    .frame(
                                        width: 15, height: 15)
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

// struct HeroListView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeroListView()
//    }
// }
