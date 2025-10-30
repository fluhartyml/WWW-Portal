//
//  ModuleManagementPanel.swift
//  WWW Portal
//
//  Created by Michael Fluharty on 10/30/25.
//


//
//  ModuleManagementPanel.swift
//  WWW Portal
//
//  Module enable/disable management panel
//

import SwiftUI

struct ModuleManagementPanel: View {
    @ObservedObject var moduleManager: ModuleManager
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Module Management")
                .font(.headline)
            
            Text("Active: \(moduleManager.activeModuleCount)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            List(moduleManager.modules) { module in
                HStack {
                    VStack(alignment: .leading) {
                        Text(module.name)
                            .font(.body)
                        Text(module.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: { module.isEnabled },
                        set: { enabled in
                            if enabled {
                                moduleManager.enableModule(module)
                            } else {
                                moduleManager.disableModule(module)
                            }
                        }
                    ))
                    
                    Circle()
                        .fill(statusColor(for: module.status))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func statusColor(for status: ModuleStatus) -> Color {
        switch status {
        case .running: return .green
        case .stopped: return .gray
        case .error: return .red
        }
    }
}