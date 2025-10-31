//
//  DDNSProvider.swift
//  WWW Portal
//
//  Created by Michael Fluharty on 10/31/25.
//


//
//  DDNSProvider.swift
//  WWW Portal
//
//  DDNS provider enumeration
//

import Foundation

enum DDNSProvider: String, Codable, CaseIterable {
    case duckDNS = "DuckDNS"
    case noIP = "No-IP"
    case dynu = "Dynu"
    case cloudflare = "Cloudflare"
    case custom = "Custom"
}