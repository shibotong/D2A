//
//  DebugPanelView.swift
//  D2A
//
//  Created by Shibo Tong on 2/5/2026.
//

#if DEBUG
import SwiftUI

struct DebugPanelView: View {
    
    @EnvironmentObject var syncingService: StaticDataSyncingService
    @EnvironmentObject var environment: DotaEnvironment
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        List {
            Section {
                Button {
                    viewModel.deleteConstantData()
                    Task {
                        try await syncingService.startSyncing()
                    }
                    environment.selectedTab = .hero
                } label: {
                    Text("Resync Constant Data")
                }
                
                Toggle(isOn: $syncingService.useV2) {
                    Text("Use V2 Syncing")
                }
            } header: {
                Text("Constant Data")
            }
        }
    }
}

#Preview {
    DebugPanelView()
        .environmentObject(PreviewData.syncingService)
        .environmentObject(PreviewData.environment)
}

#endif
