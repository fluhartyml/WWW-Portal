//
//  DDNSService.swift
//  WWW Portal
//
//  Dynamic DNS update service supporting multiple providers
//

import Foundation
import Combine

@MainActor
class DDNSService: ObservableObject {
    @Published var isEnabled: Bool = false
    @Published var lastUpdateTime: Date?
    @Published var lastUpdateStatus: String = "Not updated"
    @Published var currentIP: String = "Unknown"
    
    private var configuration: ServerConfiguration
    private var updateTimer: Timer?
    
    init(configuration: ServerConfiguration) {
        self.configuration = configuration
        self.isEnabled = configuration.ddnsEnabled
    }
    
    func startUpdating() {
        guard configuration.ddnsEnabled else { return }
        
        isEnabled = true
        
        // Immediate update
        Task {
            await performUpdate()
        }
        
        // Schedule periodic updates
        let interval = TimeInterval(configuration.ddnsUpdateInterval * 60)
        updateTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.performUpdate()
            }
        }
    }
    
    func stopUpdating() {
        updateTimer?.invalidate()
        updateTimer = nil
        isEnabled = false
    }
    
    func performUpdate() async {
        let urlString = buildUpdateURL()
        
        guard let url = URL(string: urlString) else {
            lastUpdateStatus = "Invalid URL"
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                lastUpdateTime = Date()
                lastUpdateStatus = "Success"
                
                // Try to extract IP from response
                if let responseString = String(data: data, encoding: .utf8) {
                    parseIPFromResponse(responseString)
                }
            } else {
                lastUpdateStatus = "Failed"
            }
        } catch {
            lastUpdateStatus = "Error: \(error.localizedDescription)"
        }
    }
    
    private func buildUpdateURL() -> String {
        switch configuration.ddnsProvider {
        case .duckDNS:
            return "https://www.duckdns.org/update?domains=\(configuration.ddnsDomain)&token=\(configuration.ddnsToken)"
            
        case .noIP:
            return "https://dynupdate.no-ip.com/nic/update?hostname=\(configuration.ddnsDomain)"
            
        case .dynu:
            return "https://api.dynu.com/nic/update?hostname=\(configuration.ddnsDomain)&password=\(configuration.ddnsToken)"
            
        case .cloudflare:
            return "https://api.cloudflare.com/client/v4/zones/update"
            
        case .custom:
            return configuration.ddnsCustomURL
        }
    }
    
    private func parseIPFromResponse(_ response: String) {
        // DuckDNS returns: "OK\n1.2.3.4" or just "OK"
        let lines = response.split(separator: "\n")
        if lines.count > 1 {
            currentIP = String(lines[1])
        }
    }
    
    func updateConfiguration(_ newConfig: ServerConfiguration) {
        let wasEnabled = isEnabled
        if wasEnabled {
            stopUpdating()
        }
        configuration = newConfig
        if wasEnabled && newConfig.ddnsEnabled {
            startUpdating()
        }
    }
}
