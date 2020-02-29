//
//  LoginRequest.swift
//  zScanner
//
//  Created by Ales Teska on 29.2.20.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct LoginRequest: Request {
    typealias DataType = EmptyResponse
    
    var endpoint: Endpoint = SeaCatPKIEndpoint.login
    var method: HTTPMethod = .get
    var parameters: Parameters? = nil
    var headers: HTTPHeaders = [:]
    
    init() {}
}
