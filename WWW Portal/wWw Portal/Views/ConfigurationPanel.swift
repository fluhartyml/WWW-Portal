//
//  ConfigurationPanel.swift
//  WWW Portal
//
//  Created by Michael Fluharty on 10/30/25.
//


//
//  ConfigurationPanel.swift
//  WWW Portal
//
//  Server configuration settings editor panel
//

import SwiftUI

struct ConfigurationPanel: View {
    @State private var config: ServerConfiguration = ServerConfiguration()
    @State private var hasChanges: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Configuration")
                .font(.headline)
            
            Form {
                Section(header: Text("Network Settings")) {
                    HStack {
                        Text("REST API Port:")
                        TextField("8080", value: $config.restAPIPort, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                            .onChange(of: config.restAPIPort) { _ in hasChanges = true }
                    }
                    
                    HStack {
                        Text("WebSocket Port:")
                        TextField("8081", value: $config.webSocketPort, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                            .onChange(of: config.webSocketPort) { _ in hasChanges = true }
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
        // Placeholder: Save configuration to disk
        hasChanges = false
    }
}