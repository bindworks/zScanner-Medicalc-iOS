//
//  Config.swift
//  zScanner
//
//  Created by Jakub Skořepa on 29/06/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

enum Config {
    static let productionURL: String = "https://tempra.ikem.seacat/api-zscanner/v3"
    static let testingURL: String = "https://private-anon-7cd588d2e4-skorepak.apiary-mock.com/medicalc/v3.1"
    static let authUrl: String = "http://auth.ikem.seacat"
    
    static let currentEnvironment: Environment = .testing
    static let folderUsageHistoryCount = 3
    static let maximumNumberOfConcurentUploads = 4
    static let realmSchemaVersion: UInt64 = 1
}

//MARK: -
enum Environment {
    case production
    case testing

    var baseUrl: String {
        switch self {
            case .production: return Config.productionURL
            case .testing: return Config.testingURL
        }
    }

    var authUrl: String {
        switch self {
            case .production: return Config.authUrl
            case .testing: return ""
        }
    }
}
