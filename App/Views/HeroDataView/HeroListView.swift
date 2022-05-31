//
//  HeroListView.swift
//  App
//
//  Created by Shibo Tong on 29/10/21.
//

import SwiftUI

struct HeroListView: View {
    @EnvironmentObject var herodata: HeroDatabase
    @State var searchString: String = ""
    var searchResults: [Hero] {
        if searchString.isEmpty {
            return herodata.fetchAllHeroes()
        } else {
            return herodata.fetchAllHeroes().filter({ return $0.localizedName.lowercased().contains(searchString.lowercased()) })
        }
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 170, maximum: 200), spacing: 10, alignment: .leading), count: 2)){
                ForEach(searchResults) { hero in
                    NavigationLink(destination:
                                    HeroDetailView(vm: HeroDetailViewModel(heroID: hero.id))) {
                        buildHero(hero: hero)
                    }
                }
            }
        }
        .navigationTitle("Heroes")
        .padding(.horizontal)
        .searchable(text: $searchString, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Heroes")
        
    }
    
    @ViewBuilder private func buildHero(hero: Hero) -> some View {
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
                            .font(.custom(fontString, size: 13))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .padding(5)
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
//        NavigationView{
//            EmptyView()
//            HeroListView()
//        }
//        .environmentObject(HeroDatabase.shared)
//        .previewDevice(iPadPro12)
    }
}
