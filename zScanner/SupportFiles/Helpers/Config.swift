//
//  Config.swift
//  zScanner
//
//  Created by Jakub Skořepa on 29/06/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

enum Config {
    static let plzenUrl: String = "https://fnplzen-zscanner.seacat.io/medicalc/v3.1"
    static let testingUrl: String = "https://desolate-meadow-62603.herokuapp.com/api-zscanner/v3"
    static let apiaryUrl: String = "https://private-c4072-zscannermedicalc.apiary-mock.com/medicalc/v3.1"
    static let authURL: String = "https://fnplzen-zscanner.seacat.io/seacat"
    
    static let currentEnvironment: Environment = .production
    static let folderUsageHistoryCount = 3
    static let maximumNumberOfConcurentUploads = 4
    static let realmSchemaVersion: UInt64 = 1
    // the time converted to seconds, when success sent document, will be deleted from history
    static let documentExpirationTime: TimeInterval = 60 * 60 * 48 // 48 hours
}

//MARK: -
enum Environment {
    case production
    case testing
    case apiary

    var baseUrl: String {
        switch self {
            case .production: return Config.plzenUrl
            case .testing: return Config.testingUrl
            case .apiary: return Config.apiaryUrl
        }
    }
    
    var authUrl: String {
        switch self {
            case .production: return Config.authURL
            case .testing: return ""
            case .apiary: return ""
        }
    }
}
