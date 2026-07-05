//
//  StratzNetwork.swift
//  D2A
//
//  Created by Shibo Tong on 22/5/2026.
//

internal import Apollo
import Foundation

class StratzNetwork {
    static let shared = StratzNetwork()
    private(set) lazy var apollo: ApolloClient = {
        let token: String = {
            let token = try? Secrets.load().stratzToken
            return token ?? "no-token"
        }()
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
