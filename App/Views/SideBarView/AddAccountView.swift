//
//  AddAccountView.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import SwiftUI

struct AddAccountView: View {
    @EnvironmentObject var env: DotaEnvironment
    @ObservedObject var vm: AddAccountViewModel = AddAccountViewModel()
    var body: some View {
        NavigationView {
            buildSearchingList()
                .navigationTitle("Search")
        }
        .searchable(text: $vm.searchText, prompt: "Players, Heroes, Matches") {
            let iconWidth: CGFloat = 20
            if Int(vm.searchText) != nil {
                Label {
                    Text("Search match id \(vm.searchText)")
                        .font(.subheadline)
                } icon: {
                    Image(systemName: "gamecontroller.fill")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .frame(width: iconWidth)
                }
//                .searchCompletion(vm.searchText)
                Label {
                    Text("Search player id \(vm.searchText)")
                        .font(.subheadline)
                } icon: {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .frame(width: iconWidth)
                }
//                .searchCompletion(vm.searchText)
            }
            if !vm.searchText.isEmpty {
                Label {
                    Text("Search player \(vm.searchText)")
                        .font(.subheadline)
                } icon: {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .frame(width: iconWidth)
                }
//                .searchCompletion(vm.searchText)
            }
            if !vm.searchedHeroes.isEmpty {
                Section {
                    ForEach(vm.searchedHeroes) { hero in
                        HStack {
                            HeroImageView(heroID: hero.id, type: .icon)
                                .frame(width: 30, height: 30)
                            Text(hero.localizedName)
                        }
                        .searchCompletion(hero.localizedName)
                    }
                } header: {
                    Text("Heroes")
                }
            }
        }
        .disableAutocorrection(true)
        .onSubmit(of: .search) {
            Task {
                await vm.search(searchText: vm.searchText)
            }
        }
        
    }
    
    @ViewBuilder private func buildSearchingList() -> some View {
        if vm.searchText.isEmpty {
            VStack(spacing: 15) {
                Text("Players, Heroes, Matches")
                    .bold()
                VStack {
                    Text("Search with players id or name, ")
                        .foregroundColor(.secondaryLabel)
                    Text("hero name and match id")
                    .foregroundColor(.secondaryLabel)
                }
            }
        } else {
            List {
                if let match = vm.searchedMatch {
                    Section {
                        Text("\(match.id)")
                    } header: {
                        Text("Match")
                    }
                }
                if !vm.filterHeroes.isEmpty {
                    Section {
                        ForEach(vm.filterHeroes) { hero in
                            NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: hero.id))) {
                                HStack {
                                    HeroImageView(heroID: hero.id, type: .icon)
                                        .frame(width: 30, height: 30)
                                    Text(hero.localizedName)
                                }
                            }
                        }
                    } header: {
                        Text("Heroes")
                    }
                }
                if !vm.userProfiles.isEmpty {
                    Section {
                        ForEach(vm.userProfiles) { profile in
                            buildProfile(profile: profile)
                        }
                    } header: {
                        Text("Players")
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    @ViewBuilder private func buildProfile(profile: UserProfile) -> some View {
        HStack {
            AsyncImage(url: URL(string: profile.avatarfull)) { phase in
                let sideLength = CGFloat(40)
                let cornerRadius = CGFloat(5)
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: sideLength, height: sideLength)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: sideLength, height: sideLength)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                case .failure(_):
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: sideLength, height: sideLength)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    
                @unknown default:
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: sideLength, height: sideLength)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                }
            }
            VStack(alignment: .leading) {
                Text(profile.personaname).bold()
                Text("ID: \(profile.id.description)")
                    .foregroundColor(.secondaryLabel)
                    .font(.caption)
            }
            Spacer()
            if profile.id.description == env.registerdID {
                Image(systemName: "person.fill")
                    .foregroundColor(.primaryDota)
            }
            if env.userIDs.contains(profile.id.description) {
                Image(systemName: "star.fill")
            }
        }
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountView()
            .environmentObject(DotaEnvironment.shared)
    }
}


