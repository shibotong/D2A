//
//  ConstantsController+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 23/7/2025.
//

extension ConstantsController {
    static let preview = ConstantsController(openDotaProvider: OpenDotaConstantProvider(fetcher: MockOpenDotaConstantFetcher()))
}
