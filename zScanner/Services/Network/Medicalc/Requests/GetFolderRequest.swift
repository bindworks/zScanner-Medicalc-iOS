//
//  GetFolderRequest.swift
//  zScanner
//
//  Created by Jan Provazník on 14/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct GetFolderRequest: Request, ParametersURLEncoded {
    typealias DataType = FolderNetworkModel
    
    var endpoint: Endpoint = MedicalcEndpoint.folderDecode
    var method: HTTPMethod = .get
    var parameters: Parameters?
    var headers: HTTPHeaders = [:]
    
    init(with id: String) {
        parameters = ["query": id]
    }
}
