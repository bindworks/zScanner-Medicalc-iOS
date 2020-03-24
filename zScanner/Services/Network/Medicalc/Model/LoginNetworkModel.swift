//
//  AuthNetworkModel.swift
//  zScanner
//
//  Created by Jakub Skořepa on 26/08/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct LoginNetworkModel: Encodable {
    var username: String
    var password: String
}
