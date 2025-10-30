//
//  ServerControlPanel.swift
//  WWW Portal
//
//  Server start/stop control and status display panel
//  2025 OCT 30 1425
//

import SwiftUI

struct ServerControlPanel: View {
    @ObservedObject var server: VaporServer
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Server Control")
                .font(.headline)
            
            HStack {
                Circle()
                    .fill(server.isRunning ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
                
                Text(server.status)
                    .font(.subheadline)
            }
            
            HStack(spacing: 15) {
                Button(action: {
                    Task {
                        try? await server.start()
                    }
                }) {
                    Text("Start")
                        .frame(minWidth: 80)
                }
                .disabled(server.isRunning)
                
                Button(action: {
                    Task {
                        await server.stop()
                    }
                }) {
                    Text("Stop")
                        .frame(minWidth: 80)
                }
                .disabled(!server.isRunning)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .controlBackgroundColor))
    }
}
