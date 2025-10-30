//
//  LogViewerPanel.swift
//  WWW Portal
//
//  Created by Michael Fluharty on 10/30/25.
//


//
//  LogViewerPanel.swift
//  WWW Portal
//
//  Server and module log viewer panel
//

import SwiftUI

struct LogViewerPanel: View {
    @State private var logEntries: [String] = [
        "Server started on localhost:8080",
        "Module 'Example Module 1' enabled",
        "WebSocket connection established",
        "REST API request received: GET /status"
    ]
    
    @State private var filterText: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Log Viewer")
                .font(.headline)
            
            TextField("Filter logs...", text: $filterText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(filteredLogs, id: \.self) { entry in
                        Text(entry)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(nsColor: .textBackgroundColor))
                            .cornerRadius(4)
                    }
                }
                .padding(.horizontal)
            }
            
            HStack {
                Button("Clear Logs") {
                    logEntries.removeAll()
                }
                
                Spacer()
                
                Text("\(filteredLogs.count) entries")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var filteredLogs: [String] {
        if filterText.isEmpty {
            return logEntries
        }
        return logEntries.filter { $0.localizedCaseInsensitiveContains(filterText) }
    }
}