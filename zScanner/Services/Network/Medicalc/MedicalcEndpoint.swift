//
//  IkemEndpoint.swift
//  zScanner
//
//  Created by Jakub Skořepa on 28/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

enum MedicalcEndpoint: String, Endpoint {
    case departments = "/departments"
    case documentTypes = "/documenttypes"
    case submitDocument = "/documents/summary"
    case uploadPage = "/documents/page"
    case folderSearch = "/folders/search"
    case folderDecode = "/folders/decode"
    
    var url: String {
        return baseUrl + self.rawValue
    }
    
    private var baseUrl: String {
        return Config.currentEnvironment.baseUrl
    }
}
