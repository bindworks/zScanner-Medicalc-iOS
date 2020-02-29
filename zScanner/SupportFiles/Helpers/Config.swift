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
    static let testingURL: String = "https://desolate-meadow-62603.herokuapp.com/api-zscanner/v3"
    static let apiaryURL: String = "https://zscanner.seacat.io/"
    
    static let currentEnvironment: Environment = .apiary
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
            case .production: return Config.productionURL
            case .testing: return Config.testingURL
            case .apiary: return Config.apiaryURL
        }
    }
}
