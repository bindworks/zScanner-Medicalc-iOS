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
    
    init(with auth: AuthNetworkModel) {
        //This has to go in the body!!! of the POST request
        parameters = [
            "username": auth.username,
            
            // NOTE by Teska: Eventually protect this by encryption/bcrypt/anything
            "password": auth.password
        ]
    }
}
