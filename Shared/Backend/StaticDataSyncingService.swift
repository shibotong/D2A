//
//  StaticDataSyncingService.swift
//  D2A
//
//  Created by Shibo Tong on 27/1/2026.
//

class StaticDataSyncingService {
    
    private let openDota: OpenDotaFetching
    
    init(openDota: OpenDotaFetching = OpenDotaController.shared,
         persistance: PersistanceController) {
        self.openDota = openDota
    }
    
    func startSyncing() async {
        let context = persistenceController.shared.makeContext()
        
    }
}
