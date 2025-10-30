//
//  DebugLogger.swift
//  WWW Portal
//
//  Debug logging service for tracking app events
//  2025 OCT 30 1206
//

import Foundation
import Combine

enum DebugLogLevel {
    case info
    case warning
    case error
    case success
}

struct DebugLogEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let level: DebugLogLevel
    let message: String
}

@MainActor
class DebugLogger: ObservableObject {
    @Published var logs: [DebugLogEntry] = []
    
    static let shared = DebugLogger()
    
    func log(_ message: String, level: DebugLogLevel = .info) {
        let entry = DebugLogEntry(timestamp: Date(), level: level, message: message)
        logs.append(entry)
        
        // Keep last 500 entries
        if logs.count > 500 {
            logs.removeFirst()
        }
    }
    
    func info(_ message: String) {
        log(message, level: .info)
    }
    
    func warning(_ message: String) {
        log(message, level: .warning)
    }
    
    func error(_ message: String) {
        log(message, level: .error)
    }
    
    func success(_ message: String) {
        log(message, level: .success)
    }
    
    func clearLogs() {
        logs.removeAll()
    }
}
