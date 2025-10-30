//
//  FileManager+Extensions.swift
//  WWW Portal
//
//  FileManager helper extensions for path operations
//

import Foundation

extension FileManager {
    /// Expands tilde (~) in path to full home directory path
    static func expandedPath(_ path: String) -> String {
        return NSString(string: path).expandingTildeInPath
    }
    
    /// Creates directory if it doesn't exist
    static func ensureDirectoryExists(at path: String) throws {
        let expandedPath = expandedPath(path)
        let url = URL(fileURLWithPath: expandedPath)
        
        if !FileManager.default.fileExists(atPath: expandedPath) {
            try FileManager.default.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }
    
    /// Checks if path exists and is a directory
    static func isDirectory(at path: String) -> Bool {
        var isDirectory: ObjCBool = false
        let expandedPath = expandedPath(path)
        let exists = FileManager.default.fileExists(atPath: expandedPath, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}
