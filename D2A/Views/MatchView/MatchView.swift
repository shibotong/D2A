//
//  MatchView.swift
//  App
//
//  Created by Shibo Tong on 12/8/21.
//

import SwiftUI

struct MatchView: View {
    @ObservedObject var viewModel: MatchViewModel
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @State private var clipboardAlert = false
    
    var body: some View {
        buildStack()
            .task {
                await viewModel.loadMatch()
            }
            .alert(isPresented: $clipboardAlert) {
                Alert(title: Text("Copied to clipboard"), dismissButton: .default(Text("OK")))
            }
    }
    
    @ViewBuilder private func buildStack() -> some View {
        ScrollView {
            MatchHeadingView(radiantHeroes: viewModel.playerRowViewModels.filter { $0.isRadiant }.map { $0.heroID },
                             direHeroes: viewModel.playerRowViewModels.filter { !$0.isRadiant }.map { $0.heroID })
            buildMatchData()
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
        .navigationTitle("\(viewModel.radiantWin ? "Radiant" : "Dire") Victory")
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
            if sizeClass == .compact {
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
            } else {
                HStack(alignment: .top) {
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
    }
    
    @ViewBuilder private func buildMatchData() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                Button {
                    guard let matchID = viewModel.matchID else {
                        return
                    }
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = matchID
                    clipboardAlert = true
                } label: {
                    MatchStatCardView(icon: "doc.on.doc.fill",
                                      label: "\(viewModel.matchID ?? "")")
                }
                
                MatchStatCardView(icon: "calendar",
                                  label: viewModel.startTime)
                MatchStatCardView(icon: "clock",
                                  label: viewModel.duration)
                MatchStatCardView(icon: "rosette",
                                  label: viewModel.mode)
                MatchStatCardView(icon: "mappin.and.ellipse",
                                  label: viewModel.region)
            }
            .padding(.horizontal)
        }
    }
}

struct MatchStatCardView: View {
    var icon: String
    var label: LocalizedStringKey
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(label).lineLimit(1)
        }
        .padding(7)
        .background(Color.secondarySystemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .foregroundStyle(Color.label)
        .font(.caption)
    }
}

 struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmptyView()
            MatchView(viewModel: MatchViewModel(matchID: "7434967285"))
        }
        .environment(\.locale, .init(identifier: "zh-Hans"))
        
    }
 }

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
