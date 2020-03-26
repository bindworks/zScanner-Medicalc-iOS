//
//  SearchFoldersRequest.swift
//  zScanner
//
//  Created by Jakub Skořepa on 11/08/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct SearchFoldersRequest: Request, ParametersURLEncoded {
    typealias DataType = [FolderNetworkModel]
    
    var endpoint: Endpoint = MedicalcEndpoint.folderSearch
    var method: HTTPMethod = .get
    var parameters: Parameters?
    var headers: HTTPHeaders = [:]
    
    init(query: String) {
        parameters = ["query": query]
    }
}
