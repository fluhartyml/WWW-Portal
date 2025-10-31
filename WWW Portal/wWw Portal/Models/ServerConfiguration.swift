//
//  ServerConfiguration.swift
//  WWW Portal
//
//  Created by Michael Fluharty on 10/31/25.
//


//
//  ServerConfiguration.swift
//  WWW Portal
//
//  Server configuration model with user-configurable settings
//

import Foundation

struct ServerConfiguration {
    var restAPIPort: Int
    var webSocketPort: Int
    var bindingAddress: String
    var dropFolderPath: String
    
    // DDNS Configuration
    var ddnsEnabled: Bool
    var ddnsUpdateInterval: Int
    var ddnsProvider: DDNSProvider
    var ddnsDomain: String
    var ddnsToken: String
    var ddnsCustomURL: String
    
    init(
        restAPIPort: Int = 8080,
        webSocketPort: Int = 8081,
        bindingAddress: String = "localhost",
        dropFolderPath: String = "~/NightGard/drops",
        ddnsEnabled: Bool = false,
        ddnsUpdateInterval: Int = 5,
        ddnsProvider: DDNSProvider = .duckDNS,
        ddnsDomain: String = "",
        ddnsToken: String = "",
        ddnsCustomURL: String = ""
    ) {
        self.restAPIPort = restAPIPort
        self.webSocketPort = webSocketPort
        self.bindingAddress = bindingAddress
        self.dropFolderPath = dropFolderPath
        self.ddnsEnabled = ddnsEnabled
        self.ddnsUpdateInterval = ddnsUpdateInterval
        self.ddnsProvider = ddnsProvider
        self.ddnsDomain = ddnsDomain
        self.ddnsToken = ddnsToken
        self.ddnsCustomURL = ddnsCustomURL
    }
}