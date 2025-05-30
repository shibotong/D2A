//
//  Network.swift
//  D2A
//
//  Created by Shibo Tong on 23/9/2022.
//

import Foundation
import Combine
import Apollo
import ApolloWebSocket

class Network {
    static let shared = Network()
    private(set) var apollo: ApolloClient
    
    private var stratzToken: String
    private var cancellable: AnyCancellable?
    
    init() {
        stratzToken = UserDefaults.group.string(forKey: UserDefaults.stratzToken) ?? ""
        apollo = Self.createClient(token: stratzToken)
        setupBinding()
    }
    
    private func setupBinding() {
        cancellable = NotificationCenter.stratzToken
            .receive(on: RunLoop.main)
            .sink { [weak self] token in
                self?.updateStratzToken(token: token)
            }
    }
   
    private func updateStratzToken(token: String) {
        guard token != stratzToken else {
            return
        }
        stratzToken = token
        apollo = Self.createClient(token: stratzToken)
    }
}

extension Network {
    static func createClient(token: String) -> ApolloClient {
        let url = URL(string: "https://api.stratz.com/graphql")!
        let additionalHeaders = ["Authorization": "Bearer \(token)"]
        
        let store = ApolloStore(cache: InMemoryNormalizedCache())
        let provider = DefaultInterceptorProvider(store: store)
        let transport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                     endpointURL: url,
                                                     additionalHeaders: additionalHeaders)
        
        let webSocket = WebSocket(
            url: URL(string: "wss://api.stratz.com/graphql?jwt=\(token)")!,
            protocol: .graphql_ws
        )
        // TODO: Comment out websocket temporary
//        let webSocketTransport = WebSocketTransport(websocket: webSocket)
        
//        let splitTransport = SplitNetworkTransport(
//            uploadingNetworkTransport: transport,
//            webSocketNetworkTransport: webSocketTransport
//        )
        return ApolloClient(networkTransport: transport, store: store)
    }
}
