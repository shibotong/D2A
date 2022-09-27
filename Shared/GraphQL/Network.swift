//
//  Network.swift
//  D2A
//
//  Created by Shibo Tong on 23/9/2022.
//

import Foundation
import Apollo

class Network {
    static let shared = Network()
    private(set) lazy var apollo = {
        let token = try? Secrets.load().stratzToken
        let url = URL(string: "https://api.stratz.com/graphql")!
        
        let additionalHeaders = ["Authorization": "Bearer \(token)"]
        
        let store = ApolloStore(cache: InMemoryNormalizedCache())
        let provider = DefaultInterceptorProvider(store: store)
        let transport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                     endpointURL: url,
                                                     additionalHeaders: additionalHeaders)
        
        return ApolloClient(networkTransport: transport, store: store)
    }()
}
