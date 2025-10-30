//
//  DebugConsolePanel.swift
//  WWW Portal
//
//  Bottom debug console with auto-scrolling ticker
//  2025 OCT 30 1302
//

import SwiftUI

struct DebugConsolePanel: View {
    @ObservedObject var debugLogger: DebugLogger
    @State private var isExpanded: Bool = false
    @State private var filterText: String = ""
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header bar with scrolling ticker
            HStack(spacing: 0) {
                Image(systemName: "ant.circle.fill")
                    .foregroundColor(.green)
                    .padding(.leading, 8)
                
                // Scrolling ticker when collapsed
                if !isExpanded {
                    ScrollingTickerView(logs: debugLogger.logs)
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Debug Console")
                        .font(.headline)
                        .padding(.leading, 8)
                }
                
                Spacer()
                
                Text("\(filteredLogs.count) entries")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Button(action: { debugLogger.clearLogs() }) {
                    Image(systemName: "trash")
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 4)
                
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.up")
                }
                .buttonStyle(.plain)
                .padding(.trailing, 8)
            }
            .padding(.vertical, 8)
            .background(Color(nsColor: .controlBackgroundColor))
            
            if isExpanded {
                // Filter bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Filter logs...", text: $filterText)
                        .textFieldStyle(.plain)
                }
                .padding(6)
                .background(Color(nsColor: .textBackgroundColor))
                
                // Log entries
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 2) {
                            ForEach(filteredLogs) { entry in
                                HStack(alignment: .top, spacing: 8) {
                                    Text(entry.timestamp, style: .time)
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundColor(.secondary)
                                        .frame(width: 60, alignment: .leading)
                                    
                                    Circle()
                                        .fill(colorForLevel(entry.level))
                                        .frame(width: 6, height: 6)
                                        .padding(.top, 4)
                                    
                                    Text(entry.message)
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundColor(.primary)
                                        .textSelection(.enabled)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .id(entry.id)
                            }
                        }
                        .onChange(of: debugLogger.logs.count) { _ in
                            if let lastLog = debugLogger.logs.last {
                                proxy.scrollTo(lastLog.id, anchor: .bottom)
                            }
                        }
                    }
                    .frame(height: 200)
                }
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }
    
    private var filteredLogs: [DebugLogEntry] {
        if filterText.isEmpty {
            return debugLogger.logs
        }
        return debugLogger.logs.filter { $0.message.localizedCaseInsensitiveContains(filterText) }
    }
    
    private func colorForLevel(_ level: DebugLogLevel) -> Color {
        switch level {
        case .info: return .blue
        case .warning: return .orange
        case .error: return .red
        case .success: return .green
        }
    }
}

struct ScrollingTickerView: View {
    let logs: [DebugLogEntry]
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 40) {
                ForEach(logs.suffix(10)) { entry in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(colorForLevel(entry.level))
                            .frame(width: 6, height: 6)
                        
                        Text(entry.message)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.primary)
                    }
                }
            }
            .offset(x: offset)
            .onAppear {
                startScrolling(width: geometry.size.width)
            }
            .onChange(of: logs.count) { _ in
                // Reset scroll when new log appears
                offset = geometry.size.width
            }
        }
        .frame(height: 20)
        .clipped()
    }
    
    private func startScrolling(width: CGFloat) {
        offset = width
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            offset = -width * 2
        }
    }
    
    private func colorForLevel(_ level: DebugLogLevel) -> Color {
        switch level {
        case .info: return .blue
        case .warning: return .orange
        case .error: return .red
        case .success: return .green
        }
    }
}
