//
//  LogoutRequest.swift
//  zScanner
//
//  Created by Ales Teska on 29.2.20.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct LogoutRequest: Request {
    typealias DataType = EmptyResponse
    
    var endpoint: Endpoint = SeaCatPKIEndpoint.logout
    var method: HTTPMethod = .post
    var parameters: Parameters? = nil
    var headers: HTTPHeaders = [:]
    
    init(access_token: Data) {
        //This has to go in the body!!! of the POST request
        parameters = [
            "x": access_token
        ]
    }
}
