//
//  DepartmentsRequest.swift
//  zScanner
//
//  Created by Jan Provazník on 14/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct DepartmentsRequest: Request {
    typealias DataType = [DepartmentNetworkModel]
    
    var endpoint: Endpoint = MedicalcEndpoint.departments
    var method: HTTPMethod = .get
    var parameters: Parameters? = nil
    var headers: HTTPHeaders = [:]
    
    init() {}
}
