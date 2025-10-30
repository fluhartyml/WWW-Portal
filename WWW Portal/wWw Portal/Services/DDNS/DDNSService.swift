//
//  DDNSService.swift
//  WWW Portal
//
//  Dynamic DNS update service supporting multiple providers
//  2025 OCT 30 1356
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
        guard configuration.ddnsEnabled else {
            DebugLogger.shared.warning("DDNS disabled - not starting updates")
            return
        }
        
        isEnabled = true
        DebugLogger.shared.success("DDNS service started - provider: \(configuration.ddnsProvider.rawValue)")
        
        // Immediate update
        Task {
            await performUpdate()
        }
        
        // Schedule periodic updates
        let interval = TimeInterval(configuration.ddnsUpdateInterval * 60)
        DebugLogger.shared.info("DDNS update interval: \(configuration.ddnsUpdateInterval) minutes")
        
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
        DebugLogger.shared.warning("DDNS service stopped")
    }
    
    func performUpdate() async {
        DebugLogger.shared.info("DDNS update starting for domain: \(configuration.ddnsDomain)")
        
        let urlString = buildUpdateURL()
        DebugLogger.shared.info("DDNS update URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            lastUpdateStatus = "Invalid URL"
            DebugLogger.shared.error("DDNS update failed - invalid URL: \(urlString)")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                DebugLogger.shared.info("DDNS HTTP response code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    lastUpdateTime = Date()
                    lastUpdateStatus = "Success"
                    
                    // Try to extract IP from response
                    if let responseString = String(data: data, encoding: .utf8) {
                        DebugLogger.shared.info("DDNS response: \(responseString)")
                        parseIPFromResponse(responseString)
                        DebugLogger.shared.success("DDNS updated successfully - IP: \(currentIP)")
                    } else {
                        DebugLogger.shared.success("DDNS updated successfully")
                    }
                } else {
                    lastUpdateStatus = "HTTP \(httpResponse.statusCode)"
                    DebugLogger.shared.error("DDNS update failed - HTTP status: \(httpResponse.statusCode)")
                }
            }
        } catch {
            lastUpdateStatus = "Error: \(error.localizedDescription)"
            DebugLogger.shared.error("DDNS update error: \(error.localizedDescription)")
        }
    }
    
    private func buildUpdateURL() -> String {
        switch configuration.ddnsProvider {
        case .duckDNS:
            // DuckDNS API: https://www.duckdns.org/update?domains=DOMAIN&token=TOKEN&ip=
            return "https://www.duckdns.org/update?domains=\(configuration.ddnsDomain)&token=\(configuration.ddnsToken)&ip="
            
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
        // DuckDNS returns: "OK" or "KO"
        // Some providers return IP in response
        if response.contains("OK") {
            // Try to extract IP from response if present
            let lines = response.split(separator: "\n")
            if lines.count > 1 {
                currentIP = String(lines[1])
            }
        }
    }
    
    func updateConfiguration(_ newConfig: ServerConfiguration) {
        let wasEnabled = isEnabled
        if wasEnabled {
            stopUpdating()
        }
        configuration = newConfig
        DebugLogger.shared.info("DDNS configuration updated")
        
        // Start if the NEW config has DDNS enabled (not just if it WAS enabled)
        if newConfig.ddnsEnabled {
            startUpdating()
        }
    }
}
