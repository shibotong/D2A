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

enum LoadingStatus {
    case loading, error, finish
}

class HeroDatabase: ObservableObject {
    
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
    private var abilities = [String: Ability]()
    private var heroAbilities = [String: HeroAbility]()
    private var scepterData = [HeroScepter]()
    private var apolloAbilities = [AbilityQuery.Data.Constants.Ability]()
    
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
    
    @available(iOS 17, *)
    private func saveAbilities(container: ModelContainer = SwiftDataPerisistenceController.shared.container) async {
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
    private func saveAbility(abilityID: Int, abilityName: String, ability: Ability, container: ModelContainer) async {
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
    
    @available(iOS 17, *)
    private func isScepterSkill(dname: String?) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.scepterSkillName == dname
        }).first else {
            return false
        }
        
        return hero.scepterNewSkill
    }
    
    @available(iOS 17, *)
    private func isShardSkill(dname: String?) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.shardSkillName == dname
        }).first else {
            return false
        }
        
        return hero.shardNewSkill
    }
    
    func loadData() {
        status = .loading
        gameModes = loadGameModes()
        regions = loadRegion()!
        lobbyTypes = loadLobby()!
        
        loadStratzAbilities()
        
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
            let status: LoadingStatus = self?.abilities.count == 0 ? .error : .finish
            await self?.setStatus(status: status)
        }
    }
    
    @MainActor
    private func setStatus(status: LoadingStatus) {
        openDotaLoadFinish = status
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
                    if #available(iOS 17, *) {
                        Task { [weak self] in
                            await self?.saveAbilities()
                        }
                    }
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
    
    func fetchOpenDotaAbility(name: String) -> Ability? {
        return abilities[name]
    }
    
    func fetchStratzAbility(name: String) -> AbilityQuery.Data.Constants.Ability? {
        let ability = apolloAbilities.first { $0.name == name }
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
    
    func getAbilityScepterDesc(ability: Ability, heroID: Int) -> String? {
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
    
    func isScepterSkill(ability: Ability, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.scepterSkillName && hero.scepterNewSkill
    }
    
    func isShardSkill(ability: Ability, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.shardSkillName && hero.shardNewSkill
    }
    
    func hasScepter(ability: Ability, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.scepterSkillName
    }
    
    func hasShard(ability: Ability, heroID: Int) -> Bool {
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
    
    func getAbilityShardDesc(ability: Ability, heroID: Int) -> String? {
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
        let talent = apolloAbilities.first { ability in
            return ability.id == id
        }
        return talent?.language?.displayName ?? "Fetch String Error"
    }
    
    // MARK: - private functions
    private func loadStratzAbilities() {
        Network.shared.apollo.fetch(query: AbilityQuery(language: GraphQLNullable<GraphQLEnum<Language>>.init(Language(rawValue: languageCode.rawValue) ?? .english))) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                if let abilitiesConnection = graphQLResult.data?.constants?.abilities {
                    let abilities = abilitiesConnection.compactMap({ $0 })
                    self?.apolloAbilities = abilities
                    DispatchQueue.main.async {
                        self?.stratzLoadFinish = .finish
                    }
                }
                
                if let errors = graphQLResult.errors {
                    let message = errors
                        .map { $0.localizedDescription }
                        .joined(separator: "\n")
                    DispatchQueue.main.async {
                        self?.stratzLoadFinish = .error
                    }
                    print(message)
                }
            case .failure(let error):
                print(error.localizedDescription)
                DotaEnvironment.shared.error = true
                DotaEnvironment.shared.errorMessage = error.localizedDescription
                DispatchQueue.main.async {
                    self?.stratzLoadFinish = .error
                }
            }
        }
    }
}
