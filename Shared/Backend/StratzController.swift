//
//  Network.swift
//  D2A
//
//  Created by Shibo Tong on 23/9/2022.
//

import Foundation
import CoreData
import StratzAPI
import Apollo
import ApolloWebSocket

class StratzController {
    static let shared = StratzController()
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
        
        let webSocket = WebSocket(
            url: URL(string: "wss://api.stratz.com/graphql?jwt=\(token)")!,
            protocol: .graphql_ws
        )
        let webSocketTransport = WebSocketTransport(websocket: webSocket)
        let splitTransport = SplitNetworkTransport(
            uploadingNetworkTransport: transport,
            webSocketNetworkTransport: webSocketTransport
        )
        
        return ApolloClient(networkTransport: splitTransport, store: store)
    }()
    
    private var language: GraphQLNullable<GraphQLEnum<Language>>
    
    init(language: Language = languageCode) {
        self.language = .init(Language(rawValue: language.rawValue) ?? .english)
    }
    
    func loadLocalisation() async -> LocaliseQuery.Data.Constants? {
        return await withCheckedContinuation { continuation in
            apollo.fetch(query: LocaliseQuery(language: language)) { result in
                switch result {
                case .success(let graphQLResult):
                    guard let constants = graphQLResult.data?.constants else {
                        return
                    }
                    continuation.resume(returning: constants)
                case .failure(let error):
                    print(error.localizedDescription)
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
