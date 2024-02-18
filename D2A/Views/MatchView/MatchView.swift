//
//  MatchView.swift
//  App
//
//  Created by Shibo Tong on 12/8/21.
//

import SwiftUI

struct MatchView: View {
    @ObservedObject var viewModel: MatchViewModel
    
    var body: some View {
        buildStack()
            .task {
                await viewModel.loadMatch()
            }
    }
    
    @ViewBuilder private func buildStack() -> some View {
        ScrollView {
            buildMatchData()
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
            playersView
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
            AnalysisView(players: viewModel.playerRowViewModels)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
            if let goldDiff = viewModel.goldDiff, let xpDiff = viewModel.xpDiff {
                DifferenceGraphView(vm: DifferenceGraphViewModel(goldDiff: goldDiff, xpDiff: xpDiff))
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)))
                    .frame(height: 300)
            }
        }
        .navigationTitle("ID: \(viewModel.matchID ?? "")")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            Button {
                Task {
                    await viewModel.loadMatch()
                }
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }
            
        }
    }
    
    private var playersView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Players").font(.system(size: 20)).bold().padding([.horizontal, .top])
            VStack(alignment: .leading, spacing: 0) {
                TeamView(players: viewModel.playerRowViewModels.filter({ $0.isRadiant }),
                         isRadiant: true,
                         score: viewModel.radiantKill,
                         win: viewModel.radiantWin,
                         maxDamage: viewModel.maxDamage)
                TeamView(players: viewModel.playerRowViewModels.filter({ !$0.isRadiant }),
                         isRadiant: false,
                         score: viewModel.direKill,
                         win: !viewModel.radiantWin,
                         maxDamage: viewModel.maxDamage)
            }
        }
    }
    
    @ViewBuilder private func buildMatchData() -> some View {
        VStack(spacing: 30) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    MatchStatCardView(icon: "calendar",
                                      title: "Start Time",
                                      label: viewModel.startTime)
                    .frame(width: 140)
                    MatchStatCardView(icon: "clock",
                                      title: "Duration",
                                      label: viewModel.duration)
                    .colorInvert()
                    .frame(width: 140)
                    MatchStatCardView(icon: "rosette",
                                      title: "Game Mode",
                                      label: viewModel.mode)
                    .frame(width: 140)
                    MatchStatCardView(icon: "mappin.and.ellipse",
                                      title: "Region",
                                      label: viewModel.region)
                    .colorInvert()
                    .frame(width: 140)
                }.padding(.horizontal)
            }
        }.padding([.top])
    }
}

struct MatchStatCardView: View {
    var icon: String
    var title: LocalizedStringKey
    var label: LocalizedStringKey
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15.0).foregroundColor(Color(.secondarySystemBackground))
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Image(systemName: icon).font(.title)
                    Spacer()
                    Text(title).font(.system(size: 10)).foregroundColor(Color(.secondaryLabel))
                    Text(label).font(.system(size: 15)).bold().lineLimit(2)
                }
                Spacer()
            }.padding(18)
        }
    }
}
//
// struct MatchView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            MatchView(matchid: "7434967285")
//        }
//        .environmentObject(HeroDatabase.shared)
//        .environmentObject(DotaEnvironment.shared)
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//        .environment(\.locale, .init(identifier: "zh-Hans"))
//        
//    }
// }

struct DifferenceView: View {
    var body: some View {
        ZStack {
            VStack {
                Rectangle().frame(height: 1)
                Spacer()
                Rectangle().frame(height: 1)
                Spacer()
                Rectangle().frame(height: 1)
            }
        }
    }
}
