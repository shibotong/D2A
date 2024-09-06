//
//  Network.swift
//  D2A
//
//  Created by Shibo Tong on 23/9/2022.
//

import Foundation
import Apollo
//import ApolloWebSocket

class Network {
    static let shared = Network()
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
        
        
//        let webSocket = WebSocket(
//            url: URL(string: "wss://api.stratz.com/graphql?jwt=\(token)")!,
//            protocol: .graphql_ws
//        )
//        
//        let webSocketTransport = WebSocketTransport(websocket: webSocket)
//        
//        let splitTransport = SplitNetworkTransport(
//            uploadingNetworkTransport: transport,
//            webSocketNetworkTransport: webSocketTransport
//        )
        
//        return ApolloClient(networkTransport: splitTransport, store: store)
    }()
}
