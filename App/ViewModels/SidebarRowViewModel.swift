//
//  SidebarRowViewModel.swift
//  App
//
//  Created by Shibo Tong on 17/8/21.
//

import Foundation
import CoreData

class SidebarRowViewModel: ObservableObject {
    @Published var profile: UserProfile?
    var userid: String
    
    init(userid: String) {
        self.userid = userid
        self.loadProfile()
    }
    
    private func loadProfile() {
        
        let managedObject = CoreDataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        let userid = userid
        request.predicate = NSPredicate(format: "id == %d", Int64(userid)!)
        do {
            let fetchedUser = try managedObject.fetch(request) as! [UserProfile]
            if fetchedUser.isEmpty {
                OpenDotaController.loadUserData(userid: userid) { profile in
                    self.profile = profile?.profile
                }
            } else {
                self.profile = fetchedUser.first!
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
    }
}
