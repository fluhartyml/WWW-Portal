//
//  ConfigurationPanel.swift
//  WWW Portal
//
//  Server configuration settings editor panel
//  2025 OCT 30 1402
//

import SwiftUI

struct ConfigurationPanel: View {
    @State private var config: ServerConfiguration = ServerConfiguration.load()
    @State private var hasChanges: Bool = false
    @EnvironmentObject var ddnsService: DDNSService
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Configuration")
                .font(.headline)
            
            Form {
                Section(header: Text("Network Settings")) {
                    HStack {
                        Text("REST API Port:")
                        TextField("8080", text: Binding(
                            get: { String(config.restAPIPort) },
                            set: { config.restAPIPort = Int($0) ?? 8080; hasChanges = true }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                    }
                    
                    HStack {
                        Text("WebSocket Port:")
                        TextField("8081", text: Binding(
                            get: { String(config.webSocketPort) },
                            set: { config.webSocketPort = Int($0) ?? 8081; hasChanges = true }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                    }
                    
                    HStack {
                        Text("Binding Address:")
                        TextField("localhost", text: $config.bindingAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                            .onChange(of: config.bindingAddress) { _ in hasChanges = true }
                    }
                }
                
                Section(header: Text("Paths")) {
                    HStack {
                        Text("Drop Folder:")
                        TextField("~/NightGard/drops", text: $config.dropFolderPath)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: config.dropFolderPath) { _ in hasChanges = true }
                    }
                }
                
                Section(header: Text("Dynamic DNS")) {
                    Toggle("Enable DDNS", isOn: $config.ddnsEnabled)
                        .onChange(of: config.ddnsEnabled) { _ in hasChanges = true }
                    
                    if config.ddnsEnabled {
                        Picker("Provider:", selection: $config.ddnsProvider) {
                            ForEach(DDNSProvider.allCases, id: \.self) { provider in
                                Text(provider.rawValue).tag(provider)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: config.ddnsProvider) { _ in hasChanges = true }
                        
                        HStack {
                            Text("Domain/Hostname:")
                            TextField("yourdomain", text: $config.ddnsDomain)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: config.ddnsDomain) { _ in hasChanges = true }
                        }
                        
                        HStack {
                            Text("Token/Password:")
                            SecureField("token", text: $config.ddnsToken)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: config.ddnsToken) { _ in hasChanges = true }
                        }
                        
                        HStack {
                            Text("Update Interval (min):")
                            TextField("5", text: Binding(
                                get: { String(config.ddnsUpdateInterval) },
                                set: { config.ddnsUpdateInterval = Int($0) ?? 5; hasChanges = true }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 60)
                        }
                        
                        if config.ddnsProvider == .custom {
                            HStack {
                                Text("Custom Update URL:")
                                TextField("https://...", text: $config.ddnsCustomURL)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onChange(of: config.ddnsCustomURL) { _ in hasChanges = true }
                            }
                        }
                    }
                }
            }
            .padding()
            
            HStack(spacing: 15) {
                Button("Save Changes") {
                    saveConfiguration()
                }
                .disabled(!hasChanges)
                
                Button("Reset to Defaults") {
                    config = ServerConfiguration()
                    hasChanges = false
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func saveConfiguration() {
        DebugLogger.shared.info("Saving configuration changes")
        
        // Save to disk
        config.save()
        
        // Update the DDNSService with new configuration
        ddnsService.updateConfiguration(config)
        
        hasChanges = false
        DebugLogger.shared.success("Configuration saved successfully")
    }
}
