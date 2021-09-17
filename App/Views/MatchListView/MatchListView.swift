//
//  MatchListView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI

struct MatchListView: View, Equatable {
    @EnvironmentObject var env: DotaEnvironment
    @ObservedObject var vm: MatchListViewModel
    @AppStorage("selectedMatch") var selectedMatch: String?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        if vm.userid == nil {
            Text("select a user")
        } else {
            List {
                if vm.matches.isEmpty {
                    ForEach(0..<20, id:\.self) { item in
                        MatchListRowEmptyView().listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10)))
                    }
                    .onAppear {
                        vm.fetchAllData()
                    }
                } else {
                if vm.refreshing {
                        HStack {
                            Spacer()
                            LoadingView()
                                .frame(width: 32, height: 32)
                            Spacer()
                        }
                    }
                    ForEach(vm.matches, id: \.id) { match in
                        NavigationLink(
                            destination: MatchView(vm: MatchViewModel(matchid: "\(match.id)")),
                            tag: "\(match.id)",
                            selection: $selectedMatch
                        ) {
                            MatchListRowView(vm: MatchListRowViewModel(match: match))
                                
                        }.listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10)))
                    }
                    Text("Load More...")
                        .onAppear {
                            withAnimation(.linear) {
                                vm.fetchMoreData()
                            }
                        }
                    
                }
            }
//            .listStyle(PlainListStyle())
            .navigationTitle("\(vm.userProfile?.personaname ?? "")")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        withAnimation(.linear) {
                                            vm.refreshData()
                                        }
                                    }, label: {
                                        Image(systemName: "arrow.clockwise")
                                    })
                                    .keyboardShortcut("r", modifiers: .command)
            )
        }
    }
    
    static func ==(lhs: MatchListView, rhs: MatchListView) -> Bool {
        return lhs.vm.userid == rhs.vm.userid
    }
    
}



struct MatchListView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListView(vm: MatchListViewModel())
            .environmentObject(DotaEnvironment.shared)
            .environmentObject(HeroDatabase.shared)
        
    }
}