//
//  Module.swift
//  WWW Portal
//
//  Created by Michael Fluharty on 10/30/25.
//


//
//  Module.swift
//  WWW Portal
//
//  NightGard module metadata and state
//

import Foundation

struct Module: Identifiable {
    let id: UUID
    var name: String
    var isEnabled: Bool
    var status: ModuleStatus
    var description: String
    
    init(
        id: UUID = UUID(),
        name: String,
        isEnabled: Bool = false,
        status: ModuleStatus = .stopped,
        description: String = ""
    ) {
        self.id = id
        self.name = name
        self.isEnabled = isEnabled
        self.status = status
        self.description = description
    }
}

enum ModuleStatus: String {
    case running = "Running"
    case stopped = "Stopped"
    case error = "Error"
}