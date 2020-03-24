//
//  DocumentTypesRequest.swift
//  zScanner
//
//  Created by Jakub Skořepa on 28/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct DocumentTypesRequest: Request, ParametersURLEncoded {
    typealias DataType = DocumentTypesNetworkModel
    
    var endpoint: Endpoint = MedicalcEndpoint.documentTypes
    var method: HTTPMethod = .get
    var parameters: Parameters?
    var headers: HTTPHeaders = [:]
    
    init(departmentCode: String) {
        parameters = ["department": departmentCode]
    }
}
