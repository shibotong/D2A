//
//  MockOpenDotaConstantFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 22/7/2025.
//

#if DEBUG
class MockOpenDotaConstantFetcher: OpenDotaConstantFetching {
    
    private let dataProvider: PreviewDataProvider = .shared
    
    func loadService<T: Decodable>(service: OpenDotaConstantService, as type: T.Type) async -> T? {
        dataProvider.loadOpenDotaConstants(service: service, as: type)
    }
}
#endif
