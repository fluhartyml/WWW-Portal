//
//  ContentView.swift
//  WWW Portal
//
//  Main split panel container view with debug console
//  2025 OCT 30 1332
//

import SwiftUI

struct ContentView: View {
    @StateObject private var server = VaporServer(configuration: ServerConfiguration())
    @StateObject private var moduleManager = ModuleManager()
    @StateObject private var systemMonitor = SystemMonitor()
    @StateObject private var dropFolderMonitor = DropFolderMonitor(dropFolderPath: "~/NightGard/drops")
    @StateObject private var ddnsService = DDNSService(configuration: ServerConfiguration())
    @StateObject private var debugLogger = DebugLogger.shared
    
    @State private var showDebugPanel: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content area
            NavigationSplitView {
                List {
                    NavigationLink("Server Control") {
                        ServerControlPanel(server: server)
                    }
                    
                    NavigationLink("Module Management") {
                        ModuleManagementPanel(moduleManager: moduleManager)
                    }
                    
                    NavigationLink("Log Viewer") {
                        LogViewerPanel()
                    }
                    
                    NavigationLink("Configuration") {
                        ConfigurationPanel()
                            .environmentObject(ddnsService)
                    }
                    
                    NavigationLink("System Monitor") {
                        SystemMonitorPanel(systemMonitor: systemMonitor)
                    }
                    
                    NavigationLink("DDNS Status") {
                        DDNSStatusPanel(ddnsService: ddnsService)
                    }
                }
                .navigationTitle("WWW Portal")
                .frame(minWidth: 200)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        HStack(spacing: 8) {
                            Button(action: { refreshEverything() }) {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .foregroundColor(.blue)
                            }
                            .help("Refresh Everything")
                            
                            Button(action: { showDebugPanel.toggle() }) {
                                Image(systemName: "ladybug.fill")
                                    .foregroundColor(showDebugPanel ? .green : .gray)
                            }
                            .help("Toggle Debug Console")
                        }
                    }
                }
            } detail: {
                Text("Select a panel from the sidebar")
                    .foregroundColor(.secondary)
            }
            
            // Debug console at bottom
            if showDebugPanel {
                Divider()
                DebugConsolePanel(debugLogger: debugLogger)
            }
        }
        .onAppear {
            systemMonitor.startMonitoring()
            debugLogger.success("WWW Portal started")
            debugLogger.info("System monitoring active")
        }
        .onDisappear {
            systemMonitor.stopMonitoring()
            ddnsService.stopUpdating()
            debugLogger.warning("WWW Portal shutting down")
        }
    }
    
    private func refreshEverything() {
        debugLogger.info("🔄 Refreshing all services...")
        
        // Refresh system monitor
        systemMonitor.stopMonitoring()
        systemMonitor.startMonitoring()
        debugLogger.success("System monitor refreshed")
        
        // Refresh DDNS service
        if ddnsService.isEnabled {
            ddnsService.stopUpdating()
            ddnsService.startUpdating()
            debugLogger.success("DDNS service restarted")
        } else {
            debugLogger.info("DDNS service is disabled")
        }
        
        // Force immediate DDNS update if enabled
        if ddnsService.isEnabled {
            Task {
                await ddnsService.performUpdate()
            }
        }
        
        debugLogger.success("✅ All services refreshed")
    }
}
