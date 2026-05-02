//
//  DebugPanelView+ViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 2/5/2026.
//

import Foundation
import CoreData

#if DEBUG
extension DebugPanelView {
    class ViewModel: ObservableObject {
        
        private let context: NSManagedObjectContext
        private let timer: SyncingTimerProtocol
        
        init(context: NSManagedObjectContext = PersistenceProvider.shared.mainContext,
             syncingTimer: SyncingTimerProtocol = SyncingTimer.shared) {
            self.context = context
            self.timer = syncingTimer
        }
        
        func deleteConstantData() {
            batchDeleteEntity(name: "Hero")
            batchDeleteEntity(name: "Ability")
            batchDeleteEntity(name: "HeroTranslation")
            batchDeleteEntity(name: "AbilityTranslation")
            timer.resetSyncing()
        }
        
        private func batchDeleteEntity(name: String) {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: name)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs
            do {
                guard let result = try context.execute(deleteRequest) as? NSBatchDeleteResult else {
                    print("result is not NSBatchDeleteResult")
                    return
                }
                let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result.result as! [NSManagedObjectID]]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            } catch {
                print("Failed to delete entity \(name). Error: \(error)")
            }
        }
    }
}
#endif
