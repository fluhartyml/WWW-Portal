//
//  ModuleManager.swift
//  WWW Portal
//
//  Created by Michael Fluharty on 10/30/25.
//


//
//  ModuleManager.swift
//  WWW Portal
//
//  Module lifecycle and state management
//

import Foundation
import Combine

@MainActor
class ModuleManager: ObservableObject {
    @Published var modules: [Module] = []
    @Published var activeModuleCount: Int = 0
    
    init() {
        loadModules()
    }
    
    func loadModules() {
        // Placeholder: Load module definitions from disk or config
        // Discover available NightGard modules
        modules = [
            Module(name: "Example Module 1", description: "Placeholder module"),
            Module(name: "Example Module 2", description: "Another placeholder")
        ]
        updateActiveCount()
    }
    
    func enableModule(_ module: Module) {
        // Placeholder: Start module process
        // Establish connection (REST/WebSocket/XPC)
        if let index = modules.firstIndex(where: { $0.id == module.id }) {
            modules[index].isEnabled = true
            modules[index].status = .running
        }
        updateActiveCount()
    }
    
    func disableModule(_ module: Module) {
        // Placeholder: Stop module process
        // Close connections gracefully
        if let index = modules.firstIndex(where: { $0.id == module.id }) {
            modules[index].isEnabled = false
            modules[index].status = .stopped
        }
        updateActiveCount()
    }
    
    private func updateActiveCount() {
        activeModuleCount = modules.filter { $0.isEnabled }.count
    }
}