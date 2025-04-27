//
//  PersistantContainer.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

extension PersistanceController {
    static var preview: PersistanceController = {
        let result = PersistanceController(inMemory: true)
        let viewContext = result.container.viewContext
        let previewID = "preview"
        UserProfile.create(id: previewID, favourite: true, register: true, controller: result)
        UserProfile.create(id: "preview 1", favourite: true, controller: result)
        UserProfile.create(id: "preview 2", favourite: true, controller: result)
        UserProfile.create(id: "preview 3", favourite: true, controller: result)
        UserProfile.create(id: "preview 4", favourite: true, controller: result)
        _ = RecentMatch.create(userID: previewID, matchID: previewID, controller: result)
        
        let sampleData = MockOpenDotaConstantProvider().loadSampleHeroes()
        _ = try? Hero.saveData(model: sampleData["1"]!, viewContext: viewContext)
        _ = try? Hero.saveData(model: sampleData["2"]!, viewContext: viewContext)
        _ = try? Hero.saveData(model: sampleData["3"]!, viewContext: viewContext)
        _ = try? Hero.saveData(model: sampleData["4"]!, viewContext: viewContext)
        _ = try? Hero.saveData(model: sampleData["5"]!, viewContext: viewContext)
        _ = try? Hero.saveData(model: sampleData["6"]!, viewContext: viewContext)
        _ = try? Hero.saveData(model: sampleData["7"]!, viewContext: viewContext)
        _ = try? Hero.saveData(model: sampleData["8"]!, viewContext: viewContext)
        _ = try? Hero.saveData(model: sampleData["9"]!, viewContext: viewContext)
        _ = try? Hero.saveData(model: sampleData["10"]!, viewContext: viewContext)
        return result
    }()
}
