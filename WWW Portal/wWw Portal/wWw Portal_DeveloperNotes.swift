//
//  wWw Portal DeveloperNotes.swift
//  WWW Portal
//
//  Created by Michael Fluharty on 10/30/25.
//


//
//  DeveloperNotes.swift
//  WWW Portal
//
//  Persistent memory and architectural decisions for WWW Portal project
//

/*

WWW Portal — Developer Notes

PROJECT IDENTITY
================

Name: WWW Portal
Bundle ID: com.NightGard.WWW-Portal
Platform: macOS only (self-distributed, no App Store)
Distribution: Direct download from GitHub (PRO version available)
Development Environment: Xcode 26.0.1, Swift 6.2 (as of October 2025)

PURPOSE
=======

WWW Portal is the central web server hub and backbone of the NightGard ecosystem.
It runs as a personal Mac home lab web server, providing the foundation for all
NightGard system modules to communicate and integrate.

CORE ARCHITECTURE DECISIONS
============================

[2025 OCT 30 0940] (MLF) Web Server Framework: Vapor
- Full-featured Swift web framework with routing, middleware, WebSockets
- Production-ready, actively maintained, Swift 6.2 compatible
- Scales with system growth (auth, sessions, file uploads, etc.)
- Better than Swifter (too basic) or NWListener (too low-level)

[2025 OCT 30 0942] (MLF) Multi-Protocol Module System
WWW Portal supports ALL integration methods for maximum flexibility:
- REST API endpoints (standard HTTP requests/responses)
- WebSocket connections (real-time streaming, events, status)
- IPC/XPC (direct Mac process communication for local modules)
- Drop folder system (file-based integration, classic BBS door.sys style)

[2025 OCT 30 0944] (MLF) User-Configurable Paths
- Drop folder location: User-configurable (sensible default provided)
- All paths configurable via UI, no hardcoded locations
- Flexibility for different user setups and preferences

[2025 OCT 30 0945] (MLF) User-Configurable Ports
- REST API port: User-configurable
- WebSocket port: User-configurable
- All network bindings configurable (localhost vs 0.0.0.0)
- No hardcoded ports, full user control

[2025 OCT 30 0946] (MLF) Self-Contained Design Philosophy
- NO external content loading
- NO GitHub integration in app
- NO remote dependencies for core functionality
- One-stop shop - everything accessible within the app
- Example: No "view comments on GitHub" - keep users in-app

[2025 OCT 30 0947] (MLF) Split Panel System Monitoring UI
Main screen features:
- Server start/stop/monitoring
- Module management (enable/disable)
- Logs and analytics viewer
- Configuration editor
- System resource monitoring (CPU, memory, network)
- Split panel layout for organized information display

[2025 OCT 30 0948] (MLF) Clean Code Architecture
- Files kept under 100 lines through proper modularization
- Normalized folder structure with focused sub-files
- ContentView.swift stays lean - delegates to specialized views
- Each component in its own file with single responsibility

NO APP STORE SANDBOX
====================

This app is self-distributed (not App Store bound):
✅ Full system access (files, network, processes)
✅ No entitlement restrictions
✅ No sandbox limitations
✅ Direct download from GitHub
✅ PRO version available through GitHub

PROJECT STRUCTURE (PLANNED)
============================

WWW Portal/
├── WWW_PortalApp.swift          # App entry point
├── DeveloperNotes.swift          # This file
├── ContentView.swift             # Main container (delegates to panels)
│
├── Views/
│   ├── ServerControlPanel.swift     # Start/stop/status
│   ├── ModuleManagementPanel.swift  # Module enable/disable
│   ├── LogViewerPanel.swift         # Logs and analytics
│   ├── ConfigurationPanel.swift     # Settings editor
│   └── SystemMonitorPanel.swift     # CPU/memory/network stats
│
├── Models/
│   ├── ServerConfiguration.swift    # Port, binding, paths config
│   ├── Module.swift                 # Module metadata
│   └── SystemStats.swift            # Resource monitoring data
│
├── Services/
│   ├── VaporServer.swift            # Vapor engine wrapper
│   ├── ModuleManager.swift          # Module lifecycle
│   ├── DropFolderMonitor.swift      # File-based integration
│   └── SystemMonitor.swift          # Resource tracking
│
└── Utilities/
    ├── FileManager+Extensions.swift
    └── NetworkMonitor.swift

Each file stays focused, under 100 lines, single responsibility.

VAPOR INTEGRATION
=================

Dependencies added via Swift Package Manager:
- Vapor 4.x (latest stable for Swift 6.2)

Vapor provides:
- HTTP server (REST API)
- WebSocket support (real-time connections)
- Routing and middleware
- Request/response handling
- Future expansion capabilities

DEVELOPMENT WORKFLOW
====================

Following Xcode project standards from project documentation:
- Work in step-by-step increments with screenshots
- AI does all coding, human handles Xcode UI interactions
- Commit format: "YYYY MMM DD [message] (MLF) HHMM"
- GitHub for backup/sync only (no CI/CD, no automation)

CRITICAL: AI MUST CONSULT HUMAN BEFORE GENERATING FILES
- AI must ALWAYS ask permission before creating any Swift files or artifacts
- Never generate files without explicit human approval first
- Ask: "May I create [filename] containing [brief description]?"
- Wait for confirmation before proceeding
- This prevents unwanted file generation and maintains human control

COMMUNICATION STYLE
===================

- TL;DR concise responses (1-2 paragraphs unless more requested)
- Single-action instructions with screenshot pauses
- Number batched steps as 1) 2) 3) with close parenthesis
- Avoid tables and long preambles

FILE HEADERS
============

All Swift files use this header format:

//
//  FileName.swift
//  WWW Portal
//
//  Brief one-line description
//

FUTURE CONSIDERATIONS
=====================

As system grows, consider:
- Authentication system for remote access
- SSL/TLS certificate management
- Module marketplace/discovery
- Backup/restore functionality
- Performance profiling tools
- Module sandboxing for security

NOTES FOR AI ASSISTANTS
========================

When reading this file:
1. You have complete context of all architectural decisions
2. Project uses Vapor for web server backbone
3. Multi-protocol module system (REST/WS/XPC/files)
4. Everything is user-configurable (ports, paths, bindings)
5. UI is split-panel system monitoring design
6. Keep all files under 100 lines via modularization
7. Self-distributed app (no App Store restrictions)
8. Self-contained design (no remote content loading)

Ready to code without re-education.

DEVELOPER NOTES LOG
====================

Format: [YYYY MMM DD HHMM] (AUTHOR) Decision/policy description
Keep newest entries at TOP for quick scanning.

[2025 OCT 30 0952] (MLF) Critical workflow rule added: AI must ALWAYS consult human before generating any files or artifacts. Never generate without explicit approval.

[2025 OCT 30 0950] (Claude) Created DeveloperNotes.swift with complete architectural foundation and decision log for WWW Portal project.

// Add new notes above this line. Keep newest entries at the top for quick scanning.

*/
