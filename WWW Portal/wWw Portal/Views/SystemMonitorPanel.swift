//
//  SystemMonitorPanel.swift
//  WWW Portal
//
//  Created by Michael Fluharty on 10/30/25.
//


//
//  SystemMonitorPanel.swift
//  WWW Portal
//
//  System resource monitoring display panel
//

import SwiftUI

struct SystemMonitorPanel: View {
    @ObservedObject var systemMonitor: SystemMonitor
    
    var body: some View {
        VStack(spacing: 20) {
            Text("System Monitor")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 15) {
                // CPU Usage
                HStack {
                    Text("CPU Usage:")
                        .frame(width: 120, alignment: .leading)
                    ProgressView(value: systemMonitor.currentStats.cpuUsage, total: 100)
                    Text(String(format: "%.1f%%", systemMonitor.currentStats.cpuUsage))
                        .frame(width: 60, alignment: .trailing)
                        .font(.system(.body, design: .monospaced))
                }
                
                // Memory Usage
                HStack {
                    Text("Memory Usage:")
                        .frame(width: 120, alignment: .leading)
                    ProgressView(value: systemMonitor.currentStats.memoryUsagePercentage, total: 100)
                    Text(String(format: "%.1f%%", systemMonitor.currentStats.memoryUsagePercentage))
                        .frame(width: 60, alignment: .trailing)
                        .font(.system(.body, design: .monospaced))
                }
                
                // Network Upload
                HStack {
                    Text("Network Upload:")
                        .frame(width: 120, alignment: .leading)
                    Spacer()
                    Text(String(format: "%.2f KB/s", systemMonitor.currentStats.networkUploadRate / 1024))
                        .font(.system(.body, design: .monospaced))
                }
                
                // Network Download
                HStack {
                    Text("Network Download:")
                        .frame(width: 120, alignment: .leading)
                    Spacer()
                    Text(String(format: "%.2f KB/s", systemMonitor.currentStats.networkDownloadRate / 1024))
                        .font(.system(.body, design: .monospaced))
                }
            }
            .padding()
            
            Text("Last Updated: \(systemMonitor.currentStats.timestamp, style: .time)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}