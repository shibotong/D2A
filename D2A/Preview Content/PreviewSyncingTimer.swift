//
//  PreviewSyncingTimer.swift
//  D2A
//
//  Created by Shibo Tong on 23/4/2026.
//

class PreviewSyncingTimer: SyncingTimerProtocol {
    func shouldSync(key: SyncingTimerKey) -> Bool {
        return false
    }
    
    func finishSyncing(key: SyncingTimerKey) {
        return
    }
}
