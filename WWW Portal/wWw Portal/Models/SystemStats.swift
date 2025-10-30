//
//  SystemStats.swift
//  WWW Portal
//
//  Created by Michael Fluharty on 10/30/25.
//


//
//  SystemStats.swift
//  WWW Portal
//
//  System resource monitoring data model
//

import Foundation

struct SystemStats {
    var cpuUsage: Double
    var memoryUsed: UInt64
    var memoryTotal: UInt64
    var networkUploadRate: Double
    var networkDownloadRate: Double
    var timestamp: Date
    
    init(
        cpuUsage: Double = 0.0,
        memoryUsed: UInt64 = 0,
        memoryTotal: UInt64 = 0,
        networkUploadRate: Double = 0.0,
        networkDownloadRate: Double = 0.0,
        timestamp: Date = Date()
    ) {
        self.cpuUsage = cpuUsage
        self.memoryUsed = memoryUsed
        self.memoryTotal = memoryTotal
        self.networkUploadRate = networkUploadRate
        self.networkDownloadRate = networkDownloadRate
        self.timestamp = timestamp
    }
    
    var memoryUsagePercentage: Double {
        guard memoryTotal > 0 else { return 0.0 }
        return Double(memoryUsed) / Double(memoryTotal) * 100.0
    }
}