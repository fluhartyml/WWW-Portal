//
//  ServerConfiguration.swift
//  WWW Portal
//
//  Server configuration with persistence
//  2025 OCT 30 1420
//

import Foundation

enum DDNSProvider: String, CaseIterable, Codable, Sendable {
    case duckDNS = "DuckDNS"
    case noIP = "No-IP"
    case dynu = "Dynu"
    case cloudflare = "Cloudflare"
    case custom = "Custom"
}

struct ServerConfiguration: Codable, Sendable {
    var restAPIPort: Int = 8080
    var webSocketPort: Int = 8081
    var bindingAddress: String = "localhost"
    var dropFolderPath: String = "~/NightGard/drops"
    
    var ddnsEnabled: Bool = false
    var ddnsProvider: DDNSProvider = .duckDNS
    var ddnsDomain: String = ""
    var ddnsToken: String = ""
    var ddnsUpdateInterval: Int = 5
    var ddnsCustomURL: String = ""
    
    private static let storageKey = "ServerConfiguration"
    
    // Save to UserDefaults
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: Self.storageKey)
        }
    }
    
    // Load from UserDefaults
    static func load() -> ServerConfiguration {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(ServerConfiguration.self, from: data) {
            return decoded
        }
        return ServerConfiguration()
    }
}
