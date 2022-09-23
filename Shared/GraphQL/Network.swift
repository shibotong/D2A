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
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJodHRwczovL3N0ZWFtY29tbXVuaXR5LmNvbS9vcGVuaWQvaWQvNzY1NjExOTgxMTMzMDc2ODUiLCJ1bmlxdWVfbmFtZSI6Ik1yLkJPQk9CTyIsIlN1YmplY3QiOiIwMTg0NGZiOS01ZDZjLTQ2MGEtYjRmZS04OTJjNzgwZjVjMTciLCJTdGVhbUlkIjoiMTUzMDQxOTU3IiwibmJmIjoxNjYzODE4NTU4LCJleHAiOjE2OTUzNTQ1NTgsImlhdCI6MTY2MzgxODU1OCwiaXNzIjoiaHR0cHM6Ly9hcGkuc3RyYXR6LmNvbSJ9.9yUJodq--fWTzs2lWdTULjUayX7djl6hhIqsu0TNvcw"
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
