//
//  HeroListView.swift
//  App
//
//  Created by Shibo Tong on 29/10/21.
//

import SwiftUI
import CryptoKit

struct HeroListView: View {
    @EnvironmentObject var herodata: HeroDatabase
    @EnvironmentObject var env: DotaEnvironment
    @ObservedObject var vm = HeroListViewModel()
    
    var body: some View {
        buildBody()
            .navigationTitle("Heroes")
            .searchable(text: $vm.searchString.animation(.linear), placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Heroes")
            .disableAutocorrection(true)
            .toolbar {
                Menu {
                    Picker("picker", selection: $vm.gridView) {
                        Label("Icons", systemImage: "square.grid.2x2").tag(true)
                        Label("List", systemImage: "list.bullet").tag(false)
                    }
                    
                    Picker("attributes", selection: $vm.attributes) {
                        Label("All", systemImage: "").tag(HeroAttributes.all)
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
    
    @ViewBuilder private func buildBody() -> some View {
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
    }
    
    @ViewBuilder private func buildSection(heroes: [Hero], attributes: HeroAttributes) -> some View {
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
    
    @ViewBuilder private func buildMainPart(heroes: [Hero]) -> some View {
        if vm.gridView {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 170, maximum: 200), spacing: 10, alignment: .leading), count: 2)){
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
    
    @ViewBuilder private func buildHero(hero: Hero) -> some View {
        if vm.gridView {
            ZStack {
                HeroImageView(heroID: hero.id, type: .full)
                    .overlay(LinearGradient(colors: [.black.opacity(0),.black.opacity(0), .black], startPoint: .top, endPoint: .bottom))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                HStack {
                    VStack {
                        Spacer()
                        HStack {
                            Image("hero_\(hero.primaryAttr)").resizable().frame(width: 20, height: 20)
                            Text(LocalizedStringKey(hero.localizedName))
                                .font(.system(size: 12))
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
                Text(LocalizedStringKey(hero.localizedName))
                Spacer()
                Image("hero_\(hero.primaryAttr)")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }
}

struct HeroListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HeroListView()
        }
        .environmentObject(HeroDatabase.shared)
        .previewDevice(iPhone)
    }
}
