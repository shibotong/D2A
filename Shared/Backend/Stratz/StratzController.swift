//
//  StratzController.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

import Apollo
import ApolloWebSocket
import Combine
import StratzAPI
import Foundation

protocol StratzProviding {
    func loadAbilities() async -> [StratzAbility]
}

class StratzController: StratzProviding {

    static let shared = StratzController()
    
    private var apollo: ApolloClient?
    private var stratzToken: String
    private var cancellable: AnyCancellable?
    
    private let notification: D2ANotificationCenter
    
    init(notification: D2ANotificationCenter = .shared) {
        self.notification = notification
        stratzToken = UserDefaults.group.string(forKey: UserDefaults.stratzToken) ?? ""
        apollo = try? Self.createClient(token: stratzToken)
        setupBinding()
    }

    func loadAbilities() async -> [StratzAbility] {
        do {
            return try await loadStratzAbilities()
        } catch {
            logError(error.localizedDescription, category: .stratz)
            return []
        }
    }
    
    private func setupBinding() {
        cancellable = notification.stratzToken
            .sink { [weak self] token in
                self?.updateStratzToken(token: token)
            }
    }
    
    private func updateStratzToken(token: String) {
        guard token != stratzToken else {
            return
        }
        stratzToken = token
        apollo = try? Self.createClient(token: stratzToken)
    }
    
    static func createClient(token: String) throws -> ApolloClient {
        guard !token.isEmpty else {
            throw D2AError(message: "stratz token is empty")
        }
        let url = URL(string: "https://api.stratz.com/graphql")!
        let additionalHeaders = ["Authorization": "Bearer \(token)"]

        let store = ApolloStore(cache: InMemoryNormalizedCache())
        let provider = DefaultInterceptorProvider(store: store)
        let transport = RequestChainNetworkTransport(
            interceptorProvider: provider,
            endpointURL: url,
            additionalHeaders: additionalHeaders)

        // TODO: Comment out websocket temporary
        //        let webSocket = WebSocket(
        //            url: URL(string: "wss://api.stratz.com/graphql?jwt=\(token)")!,
        //            protocol: .graphql_ws
        //        )

        //        let webSocketTransport = WebSocketTransport(websocket: webSocket)

        //        let splitTransport = SplitNetworkTransport(
        //            uploadingNetworkTransport: transport,
        //            webSocketNetworkTransport: webSocketTransport
        //        )
        return ApolloClient(networkTransport: transport, store: store)
    }

    private func loadStratzAbilities() async throws -> [StratzAbility] {
        guard let apollo else {
            logWarn("No stratz token attached", category: .stratz)
            return []
        }
        return try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: AbilityQuery(language: .init(languageCode))) {
                result in
                switch result {
                case .success(let graphQLResult):
                    guard let abilitiesConnection = graphQLResult.data?.constants?.abilities else {
                        guard let errors = graphQLResult.errors else {
                            logWarn(
                                "0 abilities loaded from Stratz and no error thrown",
                                category: .stratz)
                            continuation.resume(returning: [])
                            return
                        }
                        let message =
                        errors
                            .map { $0.localizedDescription }
                            .joined(separator: "\n")
                        continuation.resume(throwing: D2AError(message: message))
                        return
                    }
                    
                    let abilities = abilitiesConnection.compactMap({ StratzAbility(ability: $0) })
                    logDebug("\(abilities.count) abilities loaded from Stratz", category: .stratz)
                    continuation.resume(returning: abilities)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
