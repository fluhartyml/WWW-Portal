//
//  ContentView.swift
//  WWW Portal
//
//  Main split panel container view
//

import SwiftUI

struct ContentView: View {
    @StateObject private var server = VaporServer(configuration: ServerConfiguration())
    @StateObject private var moduleManager = ModuleManager()
    @StateObject private var systemMonitor = SystemMonitor()
    @StateObject private var dropFolderMonitor = DropFolderMonitor(dropFolderPath: "~/NightGard/drops")
    
    var body: some View {
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
                }
                
                NavigationLink("System Monitor") {
                    SystemMonitorPanel(systemMonitor: systemMonitor)
                }
            }
            .navigationTitle("WWW Portal")
            .frame(minWidth: 200)
        } detail: {
            Text("Select a panel from the sidebar")
                .foregroundColor(.secondary)
        }
        .onAppear {
            systemMonitor.startMonitoring()
        }
        .onDisappear {
            systemMonitor.stopMonitoring()
        }
    }
}
