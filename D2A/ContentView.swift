//
//  ContentView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var data: HeroDatabase
    @EnvironmentObject var store: StoreManager
    @EnvironmentObject var syncingService: StaticDataSyncingService
    
    @FetchRequest(sortDescriptors: [])
    private var heroes: FetchedResults<Hero>
    
    var body: some View {
        Group {
            if !syncingService.isCompleted && heroes.count < 100 {
                HeroSyncingView(currentProcess: syncingService.currentProcess, totalProcess: syncingService.totalProcesses, progress: syncingService.syncingProgress)
            } else {
                NavigationHostView()
                    .sheet(isPresented: $env.subscriptionSheet, content: {
                        StoreView()
                            .environmentObject(env)
                            .environmentObject(store)
                    })
            }
        }
        .alert(isPresented: $env.error, content: {
            Alert(title: Text("Error"), message: Text(env.errorMessage), dismissButton: .cancel())
        })
        .task {
            try? await syncingService.startSyncing()
        }
        .task {
            await store.setupStore()
        }
    }
}

struct NavigationHostView: View {
    @EnvironmentObject var env: DotaEnvironment
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @FetchRequest(sortDescriptors: [],
                  predicate: NSPredicate(format: "favourite = %d", true))
    private var favouritePlayers: FetchedResults<UserProfile>
    
    private let primaryTabs: [TabSelection] = [.home, .hero, .search]
    
    var body: some View {
//        if #available(iOS 18.0, *) {
//            modernTabs
//                .tabViewStyle(.sidebarAdaptable)
//                .defaultAdaptableTabBarPlacement(.sidebar)
//        } else
        if horizontalSizeClass == .compact {
            legacyTabs
        } else {
            NavigationSplitView {
                sidebar
            } detail: {
                NavigationStack {
                    destination(for: .home)
                }
            }
        }
    }
    
    // MARK: Shared destinations and labels
    
    @ViewBuilder
    private func destination(for selection: TabSelection) -> some View {
        switch selection {
        case .home:
            HomeView()
        case .hero:
            HeroListView()
                .navigationTitle("Heroes")
        case .search:
            SearchView()
        case .setting:
            AboutUsView()
        case .user(let userid):
            PlayerProfileView(userid: userid)
        }
    }
    
    @ViewBuilder
    private func label(for selection: TabSelection) -> some View {
        switch selection {
        case .home:
            Label("Home", systemImage: "house")
        case .hero:
            Label("Heroes", systemImage: "server.rack")
        case .search:
            Label("Search", systemImage: "magnifyingglass")
        case .setting:
            Label("More", systemImage: "ellipsis")
        case .user:
            EmptyView()
        }
    }
    
    private var favouritePlayersHeader: some View {
        Text("Favorite Players")
    }
    
    // MARK: Sidebar (iOS 16/17 regular size class)
    
    private var sidebar: some View {
        List {
            ForEach(primaryTabs, id: \.self) { tab in
                NavigationLink(destination: destination(for: tab)) {
                    label(for: tab)
                }
            }
            if !favouritePlayers.isEmpty {
                Section {
                    ForEach(favouritePlayers, id: \.self) { player in
                        NavigationLink(destination: destination(for: .user(player.userId))) {
                            SidebarRowView(userid: player.userId)
                        }
                    }
                } header: {
                    favouritePlayersHeader
                }
            }
            NavigationLink(destination: destination(for: .setting)) {
                Label("About", systemImage: "info.circle")
            }
        }
        .listStyle(.sidebar)
    }
    
    // MARK: Tabs (iOS 16/17 compact size class)
    
    private var legacyTabs: some View {
        TabView(selection: $env.selectedTab) {
            ForEach(primaryTabs, id: \.self) { tab in
                NavigationView {
                    destination(for: tab)
                }
                .tabItem {
                    label(for: tab)
                }
                .tag(tab)
                .navigationViewStyle(.stack)
            }
            NavigationView {
                destination(for: .setting)
            }
            .tabItem {
                label(for: .setting)
            }
            .tag(TabSelection.setting)
            .navigationViewStyle(.stack)
        }
    }
    
    // MARK: Tabs (iOS 18+)
    
    @available(iOS 18.0, *)
    private var modernTabs: some View {
        TabView(selection: $env.selectedTab) {
            ForEach(primaryTabs, id: \.self) { tab in
                Tab(value: tab) {
                    NavigationStack {
                        destination(for: tab)
                    }
                } label: {
                    label(for: tab)
                }
            }
            Tab(value: TabSelection.setting) {
                NavigationStack {
                    destination(for: .setting)
                }
            } label: {
                label(for: .setting)
            }
            if horizontalSizeClass == .regular && !favouritePlayers.isEmpty {
                TabSection {
                    ForEach(favouritePlayers, id: \.self) { player in
                        Tab(value: TabSelection.user(player.userId)) {
                            destination(for: .user(player.userId))
                        } label: {
                            SidebarRowView(userid: player.userId)
                        }
                        
                    }
                } header: {
                    favouritePlayersHeader
                }
                .defaultVisibility(.hidden, for: .tabBar)
            }
        }
    }
}

struct SidebarRowView: View {
    @FetchRequest var profile: FetchedResults<UserProfile>
    
    init(userid: String) {
        _profile = FetchRequest<UserProfile>(sortDescriptors: [], predicate: NSPredicate(format: "id == %@", userid))
    }
    
    var body: some View {
        makeUI()
    }
    
    @ViewBuilder
    func makeUI() -> some View {
        if let profile = profile.first {
            Label {
                Text("\(profile.name ?? profile.personaname ?? "")").lineLimit(1)
            } icon: {
                ProfileAvatar(profile: profile, cornerRadius: 10)
                    .frame(width: 30, height: 30)
            }
        } else {
            ProgressView()
        }
    }
}

struct NavigationHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationHostView()
            .environmentObject(DotaEnvironment.shared)
            .environmentObject(HeroDatabase.shared)
            .environment(\.managedObjectContext, PersistenceProvider.preview.container.viewContext)
    }
}
