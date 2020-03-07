//
//  AuthBehavior.swift
//  zScanner
//
//  Created by Jakub Skořepa on 07/03/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

class AuthBehavior {
    
    private let token: String
    
    init(token: String) {
        self.token = token
    }
}

extension AuthBehavior: RequestBehavior {
    var additionalHeaders: [String: String] {
        ["Authorization": "Bearer " + token]
    }
}
