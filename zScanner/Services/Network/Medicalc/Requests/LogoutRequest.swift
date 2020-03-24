//
//  LogoutRequest.swift
//  zScanner
//
//  Created by Ales Teska on 29.2.20.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct LogoutRequest: Request, ParametersJsonEncoded {
    typealias DataType = EmptyResponse
    
    var endpoint: Endpoint = SeaCatPKIEndpoint.logout
    var method: HTTPMethod = .post
    var parameters: Parameters? = nil
    var headers: HTTPHeaders = [:]
    
    init(logout: LogoutNetworkModel) {
        if let data = logout.token.data(using: .utf8) {
            parameters = ["access_token": data]
        }
    }
}
