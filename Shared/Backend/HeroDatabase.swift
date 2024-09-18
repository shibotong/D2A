//
//  HeroDatabase.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import SwiftUI
import Combine
import StratzAPI
import SwiftData
import CoreData

enum LoadingStatus {
    case loading, error, finish
}

class HeroDatabase: ObservableObject {
    
    typealias Localisation = LocaliseQuery.Data.Constants
    
    enum HeroDataError: Error {
        case heroNotFound
    }
    
    @Published var status: LoadingStatus = .loading
    private var heroes = [String: HeroCodable]()
    private var gameModes = [String: GameMode]()
    private var lobbyTypes = [String: LobbyType]()
    private var regions = [String: String]()
    private var items = [String: Item]()
    private var itemIDTable = [String: String]()
    private var abilityIDTable = [String: String]()
    private var abilities = [String: AbilityCodable]()
    private var heroAbilities = [String: HeroAbility]()
    private var scepterData = [HeroScepter]()
    
    private var localisation: Localisation?
    
    static var shared = HeroDatabase()
    
    static var preview = HeroDatabase(preview: true)
    
    @Published private var openDotaLoadFinish: LoadingStatus = .loading
    @Published private var stratzLoadFinish: LoadingStatus = .loading
    private var cancellable = Set<AnyCancellable>()
    
    let url = "https://api.opendota.com/api/herostats"
    
    init(preview: Bool = false) {
        guard !preview else {
            self.heroes = loadSampleHero() ?? [:]
            self.abilities = loadSampleAbilities() ?? [:]
            return
        }
        setupBinding()
        loadData()
    }
    
    init(heroes: [String: HeroCodable] = [:],
         itemID: [String: String] = [:],
         items: [String: Item] = [:]) {
        self.heroes = heroes
        self.itemIDTable = itemID
        self.items = items
    }
    
    func loadData() {
        status = .loading
        gameModes = loadGameModes()
        regions = loadRegion()!
        lobbyTypes = loadLobby()!
        
        Task { [weak self] in
            async let idTable = loadItemIDs()
            async let items = loadItems()
            async let heroes = loadHeroes()
            async let abilityIDTable = loadAbilityID()
            async let abilities = loadAbilities()
            async let heroAbilities = loadHeroAbilities()
            async let scepter = loadScepter()
            
            self?.itemIDTable = await idTable
            self?.items = await items
            self?.heroes = await heroes
            self?.abilityIDTable = await abilityIDTable
            self?.abilities = await abilities
            self?.heroAbilities = await heroAbilities
            self?.scepterData = await scepter
            self?.localisation = await StratzController.shared.loadLocalisation()
            let status: LoadingStatus = self?.abilities.count == 0 ? .error : .finish
            await self?.setStatus(status: status, stratz: .finish)
            await self?.saveAbilities()
//            await self?.saveHeroes()
        }
    }
    
    @MainActor
    private func setStatus(status: LoadingStatus, stratz: LoadingStatus) {
        openDotaLoadFinish = status
        stratzLoadFinish = stratz
    }
    
    private func setupBinding() {
        Publishers
            .CombineLatest($openDotaLoadFinish, $stratzLoadFinish)
            .map({ opendota, stratz in
                if opendota == .error || stratz == .error {
                    return LoadingStatus.error
                }
                if opendota == .finish && stratz == .finish {
                    return LoadingStatus.finish
                }
                return LoadingStatus.loading
            })
            .sink { [weak self] (status: LoadingStatus) in
                self?.status = status
                if status == .finish {
                    self?.removeBinding()
                }
                
                if status == .error {
                    self?.removeBinding()
                }
                if status == .finish || status == .error {
                    self?.removeBinding()
                }
            }
            .store(in: &cancellable)
    }
    
    private func removeBinding() {
        self.cancellable = []
    }

    func fetchHeroWithID(id: Int) throws -> HeroCodable {
        guard let hero = heroes["\(id)"] else {
            throw HeroDataError.heroNotFound
        }
        return hero
    }
    
    func fetchGameMode(id: Int) -> GameMode {
        return gameModes["\(id)"]!
    }
    
    func fetchItem(id: Int) -> Item? {
        if id == 0 {
            return nil
        } else {
            guard let itemString = itemIDTable["\(id)"] else {
                return nil
            }
            guard let item = items[itemString] else {
                return nil
            }
            return item
        }
    }
    
    func fetchRegion(id: String) -> String {
        guard let region = regions[id] else {
            return "Unknown"
        }
        return region
    }
    
    func fetchLobby(id: Int) -> LobbyType {
        return lobbyTypes["\(id)"] ?? LobbyType(id: id, name: "Unknown Lobby")
    }
    
    func fetchAbilityName(id: Int) -> String? {
        guard let abilityName = abilityIDTable["\(id)"] else {
            return nil
        }
        return abilityName
    }
    
    func fetchOpenDotaAbility(name: String) -> AbilityCodable? {
        return abilities[name]
    }
    
    func fetchStratzAbility(name: String) -> LocaliseQuery.Data.Constants.Ability? {
        guard let ability = localisation?.abilities?.first(where: { $0?.name == name }) else { return nil }
        return ability
    }
    
    func fetchHeroAbility(name: String) -> [String] {
        let abilities = heroAbilities[name]?.abilities
        return abilities ?? []
    }
    
    func fetchAllHeroes() -> [HeroCodable] {
        var sortedHeroes = [HeroCodable]()
        for i in 1..<150 {
            if let hero = heroes["\(i)"] {
                sortedHeroes.append(hero)
            }
        }
        
        sortedHeroes.sort { hero1, hero2 in
            return hero1.localizedName < hero2.localizedName
        }
        return sortedHeroes
    }
    
    func fetchSearchedHeroes(text: String) -> [HeroCodable] {
        return []
    }
    
    func getAbilityScepterDesc(ability: AbilityCodable, heroID: Int) -> String? {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return nil
        }
        if ability.dname == hero.scepterSkillName {
            return hero.scepterDesc
        }
        return nil
    }
    
    func isScepterSkill(ability: AbilityCodable, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.scepterSkillName && hero.scepterNewSkill
    }
    
    func isShardSkill(ability: AbilityCodable, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.shardSkillName && hero.shardNewSkill
    }
    
    func hasScepter(ability: AbilityCodable, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.scepterSkillName
    }
    
    func hasShard(ability: AbilityCodable, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        if ability.dname == hero.shardSkillName {
            return true
        } else {
            return false
        }
    }
    
    func getAbilityShardDesc(ability: AbilityCodable, heroID: Int) -> String? {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return nil
        }
        if ability.dname == hero.shardSkillName {
            print("\(hero.shardDesc)")
            return hero.shardDesc
        }
        return nil
    }
    
    func getTalentDisplayName(id: Short) -> String {
        guard let talent = localisation?.abilities?.first(where: { $0?.id == id }) else {
            return "Fetch String Error"
        }
        return talent?.language?.displayName ?? "Fetch String Error"
    }
    
    /// Save Heroes
    private func saveHeroes() async {
        await saveHeroesCoreData()
    }
    
    /// Save abilities
    private func saveAbilities() async {
        await saveAbilitiesCoreData()
    }
    
    private func isScepterSkill(dname: String?) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.scepterSkillName == dname
        }).first else {
            return false
        }
        
        return hero.scepterNewSkill
    }
    
    private func isShardSkill(dname: String?) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.shardSkillName == dname
        }).first else {
            return false
        }
        
        return hero.shardNewSkill
    }
}

// MARK: - Core Data
extension HeroDatabase {
    
    private func saveHeroesCoreData(container: NSPersistentContainer = PersistenceController.shared.container) async {
        for (heroIDString, heroData) in heroes {
            guard let localisation = localisation?.heroes?.compactMap({ $0 }).first(where: { $0.id == Double(heroIDString) }) else {
                continue
            }
            
            let context = container.newBackgroundContext()
            let abilityNames = self.fetchHeroAbility(name: heroData.name)
            do {
                try Hero.save(heroData: heroData,
                              abilityNames: abilityNames,
                              localisation: localisation,
                              context: context)
                print("Save hero \(heroIDString) success")
            } catch {
                print("Save hero error \(error.localizedDescription)")
            }
        }
    }
    
    private func saveAbilitiesCoreData(container: NSPersistentContainer = PersistenceController.shared.container) async {
        let context = container.newBackgroundContext()
        if !Ability.abilitiesInserted(viewContext: context) {
            self.saveAbilitiesCoreDataBatch(context: context)
        }
    }
    
    private func saveAbilitiesCoreDataBatch(context: NSManagedObjectContext) {
        let insertRequest = createBatchInsertRequest(abilityIDTable: abilityIDTable, abilities: abilities, localisations: localisation?.abilities ?? [])
        
        insertRequest.resultType = .count
        
        do {
            let result = try context.execute(insertRequest)
            let insertResult = result as? NSBatchInsertResult
            let amountInserted = insertResult?.result as? Int
            Logger.shared.log(level: .verbose, message: "Save \(amountInserted) abilities to coredata")
        } catch {
            Logger.shared.log(level: .error, message: "Error occured on batch saving ability \(error.localizedDescription)")
        }
    }
    
    func createBatchInsertRequest(abilityIDTable: [String: String],
                                  abilities: [String: AbilityCodable],
                                  localisations: [Localisation.Ability?]) -> NSBatchInsertRequest {
        let abilityFetching = AbilityInsertFetching(abilityIDTable: abilityIDTable,
                                                    abilities: abilities,
                                                    localisations: localisations)
        
        let batchInsertRequest = NSBatchInsertRequest(entity: Ability.entity(), managedObjectHandler: { [weak self] object in
            guard let object = object as? Ability else { return false }
            guard let abilityData = abilityFetching.next() else {
                return true
            }
            var abilityType = AbilityType.none
            if self?.isScepterSkill(dname: abilityData.abilityName) ?? false {
                abilityType = .scepter
            }
            
            if self?.isShardSkill(dname: abilityData.abilityName) ?? false {
                abilityType = .shared
            }
            
            object.updateValues(abilityID: abilityData.abilityID,
                                abilityName: abilityData.abilityName,
                                ability: abilityData.ability,
                                type: abilityType,
                                localisation: abilityData.localisation)
            Logger.shared.log(level: .verbose, message: "ability insert \(abilityData.abilityName)")
            return false
        })
        return batchInsertRequest
    }
}

// MARK: - Swift Data
extension HeroDatabase {
    @available(iOS 17, *)
    private func saveAbilitiesSwiftData(container: ModelContainer = SwiftDataPerisistenceController.shared.container) async {
        for (abilityIDString, abilityName) in abilityIDTable {
            guard let ability = abilities[abilityName], let abilityID = Int(abilityIDString) else {
                continue
            }
            Task {
                await saveAbility(abilityID: abilityID, abilityName: abilityName, ability: ability, container: container)
            }
        }
    }
    
    @available(iOS 17, *)
    private func saveAbility(abilityID: Int, abilityName: String, ability: AbilityCodable, container: ModelContainer) async {
        let context = ModelContext(container)
        var fetchDescriptor = FetchDescriptor<AbilityV2>(
            predicate: #Predicate { $0.abilityID == abilityID }
        )
        fetchDescriptor.fetchLimit = 1
        var abilityData = try? context.fetch(fetchDescriptor).first
        if abilityData == nil {
            abilityData = AbilityV2(abilityID: abilityID, name: abilityName)
            context.insert(abilityData!)
        }
        
        abilityData?.dname = ability.dname
        abilityData?.imageURL = nil
        abilityData?.behaviour = ability.behavior?.transformString()
        abilityData?.targetTeam = ability.targetTeam?.transformString()
        abilityData?.targetType = ability.targetType?.transformString()
        abilityData?.dmgType = ability.damageType?.transformString()
        abilityData?.mc = ability.manaCost?.transformString()
        abilityData?.cd = ability.coolDown?.transformString()
        abilityData?.bkbPierce = ability.bkbPierce?.transformString()
        abilityData?.dispellable = ability.dispellable?.transformString()

        let attributes: [AbilityV2Attribute] = ability.attributes?.map {
            let attribute = AbilityV2Attribute(attribute: $0)
            attribute.ability = abilityData
            return attribute
        } ?? []
        attributes.forEach { context.insert($0) }
        
        let stratzAbility = fetchStratzAbility(name: abilityName)
        let languageCode = currentLanguage
        let abilityLocalisation = AbilityV2Localisation(localisation: languageCode)
        abilityLocalisation.displayName = stratzAbility?.language?.displayName ?? ""
        abilityLocalisation.lore = stratzAbility?.language?.lore
        if isScepterSkill(dname: ability.dname) {
            abilityLocalisation.scepterDescription = stratzAbility?.language?.aghanimDescription
        } else if isShardSkill(dname: ability.dname) {
            abilityLocalisation.shardDescription = stratzAbility?.language?.shardDescription
        } else {
            abilityLocalisation.scepterDescription = stratzAbility?.language?.aghanimDescription
            abilityLocalisation.shardDescription = stratzAbility?.language?.shardDescription
            abilityLocalisation.abilityDescription = stratzAbility?.language?.description?.compactMap { $0 }.joined(separator: "\n")
        }
        
        abilityLocalisation.ability = abilityData
        
        context.insert(abilityLocalisation)
    }
}
