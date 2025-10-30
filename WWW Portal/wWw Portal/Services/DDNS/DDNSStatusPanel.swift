//
//  DDNSStatusPanel.swift
//  WWW Portal
//
//  Created by Michael Fluharty on 10/30/25.
//


//
//  DDNSStatusPanel.swift
//  WWW Portal
//
//  Dynamic DNS status and control panel
//  2025 OCT 30 1153
//

import SwiftUI

struct DDNSStatusPanel: View {
    @ObservedObject var ddnsService: DDNSService
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Dynamic DNS Status")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Status:")
                        .frame(width: 120, alignment: .leading)
                    Circle()
                        .fill(ddnsService.isEnabled ? Color.green : Color.gray)
                        .frame(width: 12, height: 12)
                    Text(ddnsService.isEnabled ? "Active" : "Disabled")
                }
                
                HStack {
                    Text("Current IP:")
                        .frame(width: 120, alignment: .leading)
                    Text(ddnsService.currentIP)
                        .font(.system(.body, design: .monospaced))
                }
                
                HStack {
                    Text("Last Update:")
                        .frame(width: 120, alignment: .leading)
                    if let lastUpdate = ddnsService.lastUpdateTime {
                        Text(lastUpdate, style: .time)
                            .font(.system(.body, design: .monospaced))
                    } else {
                        Text("Never")
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Text("Update Status:")
                        .frame(width: 120, alignment: .leading)
                    Text(ddnsService.lastUpdateStatus)
                        .foregroundColor(statusColor)
                }
            }
            .padding()
            
            Button("Update Now") {
                Task {
                    await ddnsService.performUpdate()
                }
            }
            .disabled(!ddnsService.isEnabled)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var statusColor: Color {
        switch ddnsService.lastUpdateStatus {
        case "Success":
            return .green
        case "Not updated":
            return .secondary
        default:
            return .red
        }
    }
}