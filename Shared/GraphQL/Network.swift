//
//  Network.swift
//  D2A
//
//  Created by Shibo Tong on 23/9/2022.
//

import Foundation
import Apollo
import ApolloWebSocket

class Network {
    static let shared = Network()
//    private(set) lazy var apollo: ApolloClient = {
//        let token = try? Secrets.load().stratzToken
//        let url = URL(string: "https://api.stratz.com/graphql")!
//        let additionalHeaders = ["Authorization": "Bearer \(token ?? "no-token")"]
//        let provider = DefaultInterceptorProvider(store: store)
//        let transport = RequestChainNetworkTransport(interceptorProvider: provider,
//                                                     endpointURL: url,
//                                                     additionalHeaders: additionalHeaders)
//
//        return ApolloClient(networkTransport: transport, store: store)
//    }()
    
    /// A web socket transport to use for subscriptions
    private lazy var webSocketTransport: WebSocketTransport = {
        let token = try? Secrets.load().stratzToken
        print("token: \(token)")
        let urlString = "https://api.stratz.com/graphql?jwt=\(token ?? "no-token")"
        print(urlString)
        let url = URL(string: urlString)!
        let webSocketClient = WebSocket(url: url, protocol: .graphql_ws)
        return WebSocketTransport(websocket: webSocketClient)
        
    }()
    
    /// An HTTP transport to use for queries and mutations
    private lazy var normalTransport: RequestChainNetworkTransport = {
        let token = try? Secrets.load().stratzToken
        let url = URL(string: "https://api.stratz.com/graphql")!
        let additionalHeaders = ["Authorization": "Bearer \(token ?? "no-token")"]
        let provider = DefaultInterceptorProvider(store: self.store)
        return RequestChainNetworkTransport(interceptorProvider: provider,
                                            endpointURL: url,
                                            additionalHeaders: additionalHeaders)
    }()
    
    /// A split network transport to allow the use of both of the above
    
    /// transports through a single `NetworkTransport` instance.
    private lazy var splitNetworkTransport = SplitNetworkTransport(
        uploadingNetworkTransport: self.normalTransport,
        webSocketNetworkTransport: self.webSocketTransport
    )
    
    /// Create a client using the `SplitNetworkTransport`.
    private(set) lazy var apollo = ApolloClient(networkTransport: self.splitNetworkTransport, store: self.store)
    
    /// A common store to use for `normalTransport` and `client`.
    private lazy var store = ApolloStore()
}
