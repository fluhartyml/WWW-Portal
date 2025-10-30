//
//  ServerConfiguration.swift
//  WWW Portal
//
//  Created by Michael Fluharty on 10/30/25.
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
    
    init(
        restAPIPort: Int = 8080,
        webSocketPort: Int = 8081,
        bindingAddress: String = "localhost",
        dropFolderPath: String = "~/NightGard/drops"
    ) {
        self.restAPIPort = restAPIPort
        self.webSocketPort = webSocketPort
        self.bindingAddress = bindingAddress
        self.dropFolderPath = dropFolderPath
    }
}