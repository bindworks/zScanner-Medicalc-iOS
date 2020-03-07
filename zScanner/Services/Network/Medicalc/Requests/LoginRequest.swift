//
//  LoginRequest.swift
//  zScanner
//
//  Created by Ales Teska on 29.2.20.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct LoginRequest: Request, ParametersQSEncoded {
    typealias DataType = LoginNetworkModel
    
    var endpoint: Endpoint = SeaCatPKIEndpoint.login
    var method: HTTPMethod = .post
    var parameters: Parameters? = nil
    var headers: HTTPHeaders = [:]
    
    init(username: String, password: String) {
        //This has to go in the body!!! of the POST request
        parameters = [
            "username": username,
            "password": password // Eventually protect this by encryption/bcrypt/anything
        ]
    }
}
