//
//  SeaCatPKIEndpoint.swift
//  zScanner
//
//  Created by Ales Teska on 29.2.20.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

enum SeaCatPKIEndpoint: String, Endpoint {
    case login = "/login"
    case logout = "/logout"
    
    var url: String {
        return baseUrl + self.rawValue
    }
    
    private var baseUrl: String {
        return Config.currentEnvironment.baseUrl
    }
}
